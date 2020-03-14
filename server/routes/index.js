const express = require("express");

const googleAuth = require("../authentication/googleAuth");
const generateToken = require("../authentication/generateTokenById");
const auth = require("../authentication");
const db = require("../models");

const router = express.Router();

/* GET home page. */
router.route("/test").get(function(req, res, next) {
  res.send({ title: "Express" });
});

router.get("/profile", auth, (req, res, next) => {
  res.send({
    user: req.user
  });
});

router.route("/google/token").post(async (req, res, next) => {
  try {
    const code = req.body.code;
    const idToken = await googleAuth.getIdToken(code);
    const profile = await googleAuth.getProfileInfo(idToken);
    let users = await db.User.findAll({
      where: { googleId: profile.sub },
      raw: true
    });
    let user;
    if (!users.length) {
      user = await db.User.create({
        googleId: profile.sub,
        name: profile.name,
        firstName: profile.given_name,
        lastName: profile.family_name,
        email: profile.email,
        profilePic: profile.picture
      });
    } else {
      user = users[0];
    }
    const token = generateToken(user.email);
    res.send({ user, token });
  } catch (e) {
    console.error(e);
    res.status(401).send();
  }
});

module.exports = router;
