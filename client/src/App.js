import React, { useState, useEffect } from "react";
import { BrowserRouter, Switch, Route } from "react-router-dom";
import axios from "axios";

import "semantic-ui-css/semantic.min.css";

import Home from "./Home";
import Login from "./Login";
import AuthenticatedRoute from "./AuthenticatedRoute";

function App() {
  const [isUserAuthenticated, setIsUserAuthenticated] = useState(false);
  useEffect(() => {
    onLoad();
  }, []);
  async function onLoad() {
    try {
      const response = await axios.get("api/profile");
      if (response.data.user) {
        setIsUserAuthenticated(true);
      }
    } catch (error) {
      console.error(error);
    }
  }
  return (
    <BrowserRouter>
      <Switch>
        <Route component={Login} exact path="/login" />
        <AuthenticatedRoute
          path="/"
          component={Home}
          appProps={{ isUserAuthenticated }}
        />
      </Switch>
    </BrowserRouter>
  );
}

export default App;
