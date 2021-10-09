import { Container, Flex, Heading, Spacer, Avatar, Box } from "@chakra-ui/react";
import { ByMoralis, useMoralis } from "react-moralis";
import { useState } from "react";
import { Auth } from "./Auth";
import { Route, Switch, Redirect, Link } from "react-router-dom";
import { Home } from "./Home";
import { Profile } from "./Profile";

const Moralis = require('moralis');

function App() {
  const { isAuthenticated, logout, user, isAuthUndefined } = useMoralis();

  return (
    <Container w="1200px" maxWidth="100ch">
      <Flex my={6}>
        <Link to="/" exact>
          <Heading>Home</Heading>
        </Link>
        <Spacer />
        {isAuthenticated && (
          <Link to="/profile" exact>
            <Avatar name={user.attributes.username} />
          </Link>
        )}
      </Flex>

      <Heading mb={6}>Welcome to Phantasm Finance, {user ? user.attributes.username : " Authenticate Please"}</Heading>
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
      <Box mt={6}>
        <ByMoralis />
      </Box>
    </Container>
  );
}

export default App;
