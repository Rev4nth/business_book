const express = require("express");
const router = express.Router();

const db = require("../models");
const auth = require("../authenticate");

router
  .route("/")
  .get(auth, async (req, res, next) => {
    try {
      const sales = await db.Sale.findAll({
        attributes: ["id", "description", "amount", "saleDate"],
        include: [{ model: db.Customer }]
      });
      res.json(sales);
    } catch (error) {
      res.status(500).send({
        error
      });
    }
  })
  .post(auth, async (req, res, next) => {
    try {
      console.log(req.body);
      const sale = await db.Sale.create({
        description: req.body.description,
        amount: parseInt(req.body.amount),
        saleDate: req.body.date,
        customerId: req.body.customerId
      });
      res.json(sale);
    } catch (error) {
      res.status(500).send({
        error
      });
    }
  });

router
  .route("/:saleId")
  .get(auth, async (req, res, next) => {
    try {
      const sales = await db.Sale.findAll({
        where: {
          id: req.params.saleId
        }
      });
      res.json(sale);
    } catch (error) {
      res.status(500).send({
        error
      });
    }
  })
  .put(auth, async (req, res, next) => {
    try {
      const sale = await db.Sale.update(
        { where: { id: req.params.saleId } },
        {
          description: req.body.description,
          amount: parseInt(req.body.amount)
          //   accountId: parseInt(req.params.accountId)
          // saleDate: req.body.saleDate
        }
      );
      res.json(sale);
    } catch (error) {
      res.status(500).send({
        error
      });
    }
  });

module.exports = router;
