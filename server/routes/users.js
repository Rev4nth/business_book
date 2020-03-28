const express = require("express");
const router = express.Router();

const db = require("../models");
const generateToken = require("../generateToken");

router.route("/token").post(async (req, res, next) => {
  try {
    let users = await db.User.findAll({
      where: { email: req.body.email },
      raw: true
    });
    let user;
    if (!users.length) {
      user = await db.User.create({
        displayName: req.body.displayName,
        email: req.body.email
      });
    } else {
      user = users[0];
    }
    const token = generateToken(user.email);
    res.send({ user, token });
  } catch (error) {
    console.log(error);
    res.status(500).send({
      error
    });
  }
});

module.exports = router;
