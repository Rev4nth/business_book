"use strict";
module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define(
    "User",
    {
      firstName: DataTypes.STRING,
      lastName: DataTypes.STRING,
      email: DataTypes.STRING,
      contact: DataTypes.STRING,
      name: DataTypes.STRING,
      googleId: DataTypes.STRING,
      accountName: DataTypes.STRING
    },
    {}
  );
  User.associate = function(models) {
    User.hasMany(models.Sale);
    User.hasMany(models.Customer);
  };
  return User;
};
