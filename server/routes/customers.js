var express = require("express");
var router = express.Router();

var db = require("../models");
const auth = require("../authenticate");
const Op = db.Sequelize.Op;

router
  .route("/")
  .get(auth, async (req, res, next) => {
    try {
      const customers = await db.Customer.findAll({
        attributes: ["id", "name", "contact"],
        where: {
          userId: req.user.id,
        },
      });
      res.json(customers);
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  })
  .post(auth, async (req, res, next) => {
    try {
      const customersContacts = await db.Customer.findAll({
        where: {
          userId: req.user.id,
          contact: req.body.contact,
        },
      });
      const customersNames = await db.Customer.findAll({
        where: {
          userId: req.user.id,
          $col: db.sequelize.where(
            db.sequelize.fn("lower", db.sequelize.col("name")),
            db.sequelize.fn("lower", req.body.name)
          ),
        },
      });
      if (customersContacts.length > 0) {
        res.status(400).send({
          error: "Customer with this contact number already exists",
        });
      } else if (customersNames.length > 0) {
        res.status(400).send({
          error: "Customer with this name already exists",
        });
      } else {
        const customer = await db.Customer.create({
          name: req.body.name,
          contact: req.body.contact,
          userId: req.user.id,
        });
        res.json(customer);
      }
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  });

router
  .route("/:customerId")
  .get(auth, async (req, res, next) => {
    try {
      const customer = await db.Customer.findOne({
        attributes: ["id", "name", "contact"],
        where: {
          id: req.params.customerId,
        },
      });
      res.json(customer);
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  })
  .put(auth, async (req, res, next) => {
    try {
      const customersContacts = await db.Customer.findAll({
        where: {
          userId: req.user.id,
          contact: req.body.contact,
          id: { [Op.not]: req.params.customerId },
        },
      });
      const customersNames = await db.Customer.findAll({
        where: {
          userId: req.user.id,
          id: { [Op.not]: req.params.customerId },
          [Op.col]: db.sequelize.where(
            db.sequelize.fn("lower", db.sequelize.col("name")),
            db.sequelize.fn("lower", req.body.name)
          ),
        },
      });
      if (customersContacts.length > 0) {
        res.status(400).send({
          error: "Customer with this contact number already exists",
        });
      } else if (customersNames.length > 0) {
        res.status(400).send({
          error: "Customer with this name already exists",
        });
      } else {
        const customer = await db.Customer.update(
          {
            name: req.body.name,
            contact: req.body.contact,
            userId: req.user.id,
          },
          { where: { id: req.params.customerId } }
        );
        res.json(customer);
      }
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  });

module.exports = router;
