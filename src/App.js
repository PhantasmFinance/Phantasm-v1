import { Container, Flex, Heading, Spacer, Avatar, Box } from "@chakra-ui/react";
import { ByMoralis, useMoralis } from "react-moralis";
import { useState } from "react";
import axios from 'axios';
import { Auth } from "./Auth";
import { Route, Switch, Redirect, Link } from "react-router-dom";
import { Home } from "./Home";
import { Profile } from "./Profile";
import { useEffect } from 'react';


const Moralis = require('moralis');

function App() {
  const { isAuthenticated, logout, user, isAuthUndefined } = useMoralis();
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [items, setItems] = useState([]);
  


  return (
    <Container maxWidth="900ch">
      <Flex my={6}>
        <Link to="/" exact>
          <Heading>Home</Heading>
        </Link>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;

        <Link to="/profile" exact>
          <Heading>Profile</Heading>
        </Link>
        <Spacer />
        {isAuthenticated && (
          <Link to="/profile" exact>
            <Avatar name={user.attributes.username} />
          </Link>
        )}
      </Flex>

      <Heading class="heading"mb={5}>Welcome to Phantasm Finance, {user ? user.attributes.username : " Authenticate Please"}</Heading>
      {isAuthenticated ? (
        <Switch>
          <Route path="/" exact>
            <Home />
          </Route>
          <Route path="/profile" exact>
            <Profile />
          </Route>
        </Switch>
      ) : (
        <>
          {!isAuthUndefined && <Redirect to="/" />}
          <Auth />
        </>
      )}


    </Container>
  );
}

export default App;
