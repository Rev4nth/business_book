const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const cors = require("cors");
require("dotenv").config();

const indexRouter = require("./routes/index");
const usersRouter = require("./routes/users");
const salesRouter = require("./routes/sales");
const expensesRouter = require("./routes/expenses");
const customersRouter = require("./routes/customers");
const imagesRouter = require("./routes/images");

const app = express();
app.use(
  cors({
    origin: "http://localhost:5000",
  })
);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

app.use("/", indexRouter);
app.use("/api/users/", usersRouter);
app.use("/api/sales/", salesRouter);
app.use("/api/expenses/", expensesRouter);
app.use("/api/customers/", customersRouter);
app.use("/api/images/", imagesRouter);

module.exports = app;
