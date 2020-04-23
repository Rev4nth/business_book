"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface.addColumn("Users", "accountId", {
      type: Sequelize.INTEGER,
      references: {
        model: "Accounts",
        key: "id",
      },
      onUpdate: "CASCADE",
      onDelete: "SET NULL",
    });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.removeColumn("Users", "accountId");
  },
};
