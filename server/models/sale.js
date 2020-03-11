"use strict";
module.exports = (sequelize, DataTypes) => {
  const Sale = sequelize.define(
    "Sale",
    {
      description: DataTypes.TEXT,
      amount: DataTypes.INTEGER,
      saleDate: DataTypes.DATE
    },
    {}
  );
  Sale.associate = function(models) {
    Sale.belongsTo(models.User);
    Sale.belongsTo(models.Customer);
  };
  return Sale;
};
