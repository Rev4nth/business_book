const express = require("express");
const router = express.Router();

const db = require("../models");
const generateToken = require("../generateToken");
const googleAuth = require("../googleAuth");
const auth = require("../authenticate");

router.route("/token").post(async (req, res, next) => {
  try {
    const idToken = req.body.idToken;
    const profile = await googleAuth.getProfileInfo(idToken);
    let users = await db.User.findAll({
      where: { email: profile.email },
      raw: true,
    });
    let user;
    if (!users.length) {
      user = await db.User.create({
        displayName: profile.name,
        email: profile.email,
      });
    } else {
      user = users[0];
    }
    const token = generateToken(user.email);
    res.send({ user, token });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      error: error.toString(),
    });
  }
});

router.route("/profile").get(auth, async (req, res, next) => {
  try {
    const user = await db.User.findOne({
      where: {
        id: req.user.id,
      },
      include: [{ model: db.Account }],
    });
    res.json(user);
  } catch (error) {
    res.status(500).send({
      error: error.toString(),
    });
  }
});

router.route("/account").post(auth, async (req, res, next) => {
  try {
    console.log(req.body.accountName);
    const account = await db.Account.create({
      name: req.body.accountName,
    });
    const user = await db.User.findOne({
      where: {
        id: req.user.id,
      },
    });
    const updatedUser = await user.setAccount(account);
    res.send({ user: updatedUser });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      error: error.toString(),
    });
  }
});

module.exports = router;
