const express = require("express");
const router = express.Router();

const db = require("../models");
const generateToken = require("../generateToken");

router.route("/").get((req, res, next) => {
  res.json({
    app: "bbc",
  });
});

module.exports = router;
