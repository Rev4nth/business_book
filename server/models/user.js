"use strict";
module.exports = (sequelize, DataTypes) => {
  const User = sequelize.define(
    "User",
    {
      displayName: DataTypes.STRING,
      email: DataTypes.STRING,
    },
    {}
  );
  User.associate = function (models) {
    User.belongsTo(models.Account, {
      foreignKey: "accountId",
    });
  };
  return User;
};
