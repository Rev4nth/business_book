require("dotenv").config();

module.exports = {
  development: {
    username: "me",
    password: "rb123",
    database: "business_book",
    host: "127.0.0.1",
    dialect: "postgres",
  },
  staging: {
    username: process.env.RDS_USERNAME,
    password: process.env.RDS_PASSWORD,
    database: process.env.RDS_DB_NAME,
    host: process.env.RDS_HOSTNAME,
    dialect: "postgres",
  },
  test: {
    username: "root",
    password: null,
    database: "database_test",
    host: "127.0.0.1",
    dialect: "postgres",
  },
  staging: {
    use_env_variable: "RDS_STAGING_DATABASE_URL",
  },
  production: {
    use_env_variable: "RDS_DATABASE_URL",
  },
};
