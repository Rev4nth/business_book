"use strict";

module.exports = {
  up: (queryInterface, Sequelize) => {
    return queryInterface
      .addColumn("Sales", "userId", {
        type: Sequelize.INTEGER,
        references: {
          model: "Users",
          key: "id",
        },
        onUpdate: "CASCADE",
        onDelete: "SET NULL",
      })
      .then(
        queryInterface.addColumn("Customers", "userId", {
          type: Sequelize.INTEGER,
          references: {
            model: "Users",
            key: "id",
          },
          onUpdate: "CASCADE",
          onDelete: "SET NULL",
        })
      );
  },

  down: (queryInterface, Sequelize) => {
    return queryInterface
      .removeColumn("Sales", "userId")
      .then(queryInterface.removeColumn("Customers", "userId"));
  },
};
