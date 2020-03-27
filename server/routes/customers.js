var express = require("express");
var router = express.Router();

var db = require("../models");

router
  .route("/")
  .get(async (req, res, next) => {
    try {
      const customers = await db.Customer.findAll({
        attributes: ["id", "name", "contact"]
      });
      res.json(customers);
    } catch (error) {
      res.json({ error });
    }
  })
  .post(async (req, res, next) => {
    try {
      const customer = await db.Customer.create({
        name: req.body.name,
        contact: req.body.contact
      });
      res.json(customer);
    } catch (error) {
      res.json({ error });
    }
  });

module.exports = router;
