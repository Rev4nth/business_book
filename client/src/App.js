import React from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";

import "semantic-ui-css/semantic.min.css";

import Home from "./Home";
import Login from "./Login";

function App() {
  return (
    <BrowserRouter>
      <Switch>
        <Route component={Login} exact path="/login" />
        <Route component={Home} path="/" />
      </Switch>
    </BrowserRouter>
  );
}

export default App;
