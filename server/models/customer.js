"use strict";
module.exports = (sequelize, DataTypes) => {
  const Customer = sequelize.define(
    "Customer",
    {
      name: DataTypes.STRING,
      contact: DataTypes.STRING
    },
    {}
  );
  Customer.associate = function(models) {
    // associations can be defined here
  };
  return Customer;
};
