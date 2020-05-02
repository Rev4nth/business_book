"use strict";
module.exports = (sequelize, DataTypes) => {
  const Expense = sequelize.define(
    "Expense",
    {
      description: DataTypes.TEXT,
      amount: DataTypes.FLOAT,
      expenseDate: DataTypes.DATEONLY,
      imageUrl: DataTypes.STRING,
    },
    {}
  );
  Expense.associate = function (models) {
    Expense.belongsTo(models.Customer, {
      foreignKey: "customerId",
    });
    Expense.belongsTo(models.User, {
      foreignKey: "userId",
    });
  };
  return Expense;
};
