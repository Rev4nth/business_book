const jwt = require("jsonwebtoken");

module.exports = email => {
  const JWT_SECRET = process.env.SECRET_KEY;
  const token = jwt.sign({ email }, JWT_SECRET);
  return token;
};
