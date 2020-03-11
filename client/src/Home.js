import React, { Component } from "react";
import { BrowserRouter as Router, withRouter } from "react-router-dom";
import { Button, Container, Menu } from "semantic-ui-react";
import axios from "axios";

class Home extends Component {
  state = {
    firstName: "",
    name: ""
  };
  componentDidMount() {
    axios.get("api/profile").then(response => {
      const user = response.data.user;
      this.setState({
        firstName: user.firstName,
        name: user.name
      });
    });
  }
  logout = () => {
    localStorage.removeItem("userToken");
    this.props.history.push("/login");
  };
  render() {
    const { firstName } = this.state;
    return (
      <Router>
        <Container>
          <Menu>
            <Menu.Menu position="right">
              <Menu.Item>{firstName}</Menu.Item>
              <Menu.Item>
                <Button onClick={this.logout}>Logout</Button>
              </Menu.Item>
            </Menu.Menu>
          </Menu>
        </Container>
      </Router>
    );
  }
}

export default withRouter(Home);
