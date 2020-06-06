const express = require("express");
const router = express.Router();

router.route("/").get((req, res, next) => {
  res.json({
    app: "business_book",
  });
});

module.exports = router;
