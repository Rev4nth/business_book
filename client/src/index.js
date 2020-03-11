import React from "react";
import ReactDOM from "react-dom";
import axios from "axios";

import App from "./App";

axios.defaults.baseURL =
  process.env.REACT_APP_REST_API_LOCATION || "http://localhost:3000";

axios.interceptors.request.use(
  function(config) {
    const userToken = JSON.parse(localStorage.getItem("userToken"));
    if (userToken != null) {
      config.headers.Authorization = `Bearer ${userToken}`;
    }
    return config;
  },
  function(err) {
    return Promise.reject(err);
  }
);

ReactDOM.render(<App />, document.getElementById("root"));
