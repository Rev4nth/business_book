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
        console.log("hee");
        const userToken = response.data.token;
        localStorage.setItem("userToken", JSON.stringify(userToken));
        axios.defaults.headers.common["Authorization"] = `Bearer ${userToken}`;
        this.props.history.push("/");
        console.log(response);
      });
  };
  // componentDidMount() {
  //   let userToken = localStorage.getItem("userToken");
  //   if (userToken) {
  //     this.props.history.push("/");
  //   }
  // }
  render() {
    return (
      <Container textAlign="center" style={{ marginTop: 240 }}>
        <GoogleLogin
          clientId="425566656483-mvtk9oc6s1rc7lm8mv53vg7nddgi138s.apps.googleusercontent.com"
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
