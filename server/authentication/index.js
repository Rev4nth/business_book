const jwt = require("jsonwebtoken");
const db = require("../models");

const auth = async (req, res, next) => {
  try {
    const token = req.header("Authorization").replace("Bearer ", "");
    const verifiedToken = jwt.verify(token, process.env.SECRET_KEY);

    const users = await db.User.findAll({
      where: {
        email: verifiedToken.email
      },
      raw: true
    });

    if (!users.length) {
      throw new Error();
    }

    req.user = users[0];
    req.token = token;
    next();
  } catch (e) {
    res.status(401).send({
      error: "You are not authenticated"
    });
  }
};

module.exports = auth;
