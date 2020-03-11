import React, { Component } from "react";
import { Container } from "semantic-ui-react";
import { withRouter } from "react-router-dom";
import { GoogleLogin } from "react-google-login";

import axios from "axios";
class Login extends Component {
  responseGoogle = response => {
    axios
      .post("api/google/token", {
        code: response["code"]
      })
      .then(response => {
        const userToken = response.data.token;
        localStorage.setItem("userToken", JSON.stringify(userToken));
        axios.defaults.headers.common["Authorization"] = `Bearer ${userToken}`;
        this.props.history.push("/");
      });
  };
  componentDidMount() {
    let userToken = localStorage.getItem("userToken");
    if (userToken) {
      this.props.history.push("/");
    }
  }
  render() {
    return (
      <Container textAlign="center" style={{ marginTop: 240 }}>
        <GoogleLogin
          clientId="573587934610-p2vasi0o1ju8uhlrosrkhdenaevtd66c.apps.googleusercontent.com"
          buttonText="Login"
          responseType="code"
          onSuccess={this.responseGoogle}
          onFailure={this.responseGoogle}
          redirectUri="postmessage"
          cookiePolicy={"single_host_origin"}
        />
      </Container>
    );
  }
}

export default withRouter(Login);
