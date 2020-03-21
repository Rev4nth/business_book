var express = require("express");
var router = express.Router();

var db = require("../models");

/* GET users listing. */
router
  .route("/")
  .get(async (req, res, next) => {
    try {
      const sales = await db.Sale.findAll({});
      res.json(sales);
    } catch (error) {
      res.json({ error });
    }
  })
  .post(async (req, res, next) => {
    try {
      console.log(req.body);
      const sale = await db.Sale.create({
        description: req.body.description,
        amount: parseInt(req.body.amount)
        //   accountId: parseInt(req.params.accountId)
        // saleDate: req.body.saleDate
      });
      res.json(sale);
    } catch (error) {
      res.json({ error });
    }
  });

router
  .route("/:saleId")
  .get(async (req, res, next) => {
    try {
      const sales = await db.Sale.findAll({
        where: {
          id: req.params.saleId
        }
      });
      res.json(sale);
    } catch (error) {
      res.json({ error });
    }
  })
  .put(async (req, res, next) => {
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
      res.json({ error });
    }
  });

module.exports = router;
