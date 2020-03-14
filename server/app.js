const express = require("express");
const path = require("path");
const cookieParser = require("cookie-parser");
const logger = require("morgan");
const cors = require("cors");
require("dotenv").config();

const indexRouter = require("./routes/index");
const usersRouter = require("./routes/users");
const salesRouter = require("./routes/sales");

const app = express();
app.use(
  cors({
    origin: "http://localhost:5000"
  })
);

app.use(logger("dev"));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, "public")));

// app.use("/api/", indexRouter);
app.use("/api/sales", salesRouter);
app.use("/users", usersRouter);

module.exports = app;
