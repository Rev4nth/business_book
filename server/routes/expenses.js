const express = require("express");
const router = express.Router();

const db = require("../models");
const auth = require("../authenticate");

router
  .route("/")
  .get(auth, async (req, res, next) => {
    try {
      const expenses = await db.Expense.findAll({
        attributes: ["id", "description", "amount", "expenseDate", "imageUrl"],
        include: [{ model: db.Customer }],
        where: {
          userId: req.user.id,
        },
      });
      res.json(expenses);
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  })
  .post(auth, async (req, res, next) => {
    try {
      const expense = await db.Expense.create({
        description: req.body.description,
        amount: parseFloat(req.body.amount),
        expenseDate: req.body.expenseDate,
        customerId: req.body.customerId,
        userId: req.user.id,
        imageUrl: req.body.imageUrl,
      });
      res.json(expense);
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  });

router
  .route("/:expenseId")
  .get(auth, async (req, res, next) => {
    try {
      const expense = await db.Expense.findOne({
        attributes: ["id", "description", "amount", "expenseDate", "imageUrl"],
        include: [{ model: db.Customer }],
        where: {
          id: req.params.expenseId,
        },
      });
      res.json(expense);
    } catch (error) {
      res.status(500).send({
        error: error.toString(),
      });
    }
  })
  .delete(auth, async (req, res, next) => {
    try {
      const isDeleted = await db.Expense.destroy({
        where: { id: req.params.expenseId },
      });
      console.log(isDeleted);
      console.log(Boolean(isDeleted));
      res.json({
        isDeleted: Boolean(isDeleted),
      });
    } catch (error) {
      res.status(500).send({
        error,
      });
    }
  });

module.exports = router;
