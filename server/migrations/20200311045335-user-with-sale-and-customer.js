"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface
      .addColumn("Sales", "userId", {
        type: Sequelize.INTEGER,
        references: { model: "Users", key: "id" },
        onUpdate: "CASCADE",
        onDelete: "SET NULL"
      })
      .then(() => {
        return queryInterface.addColumn("Sales", "customerId", {
          type: Sequelize.INTEGER,
          references: { model: "Customers", key: "id" },
          onUpdate: "CASCADE",
          onDelete: "SET NULL"
        });
      })
      .then(() => {
        return queryInterface.addColumn("Customers", "userId", {
          type: Sequelize.INTEGER,
          references: { model: "Users", key: "id" },
          onUpdate: "CASCADE",
          onDelete: "SET NULL"
        });
      });
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface.removeColumn("Sales", "accountId").then(() => {
      return queryInterface.removeColumn("Sales", "customerId").then(() => {
        return queryInterface.removeColumn("Customers", "accountId");
      });
    });
  }
};
