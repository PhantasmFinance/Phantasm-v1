import { Container, Flex, Heading, Spacer, Avatar, Menu, Box, MenuButton, MenuList, MenuItem, Image } from "@chakra-ui/react";
import { ByMoralis, useMoralis } from "react-moralis";
import { useState } from "react";
import axios from "axios";
import { Auth } from "./Auth";
import { Route, Switch, Redirect, Link } from "react-router-dom";
import { Home } from "./Home";
import { Profile } from "./Profile";
import { UpdateUser } from "./UpdateUser";
import { useEffect } from "react";
import logo from "../src/assets/ghost.png";

const Moralis = require("moralis");

function App() {
  const { isAuthenticated, logout, user, isAuthUndefined, isAuthenticating } = useMoralis();
  const [error, setError] = useState(null);
  const [isLoaded, setIsLoaded] = useState(false);
  const [items, setItems] = useState([]);

  return (
    <Container w="1200px" maxWidth="150ch">
      <Flex my={6}>
        <Link to="/" exact>
          <Image src={logo} boxSize="60px"></Image>
        </Link>
        <Spacer />
        <Box>
          <Flex>
            <Box mr="14">
              <Link to="/" exact>
                <Heading bgGradient="linear(to-r, #9D8DF1, #B8CDF8, #1CFEBA)" bgClip="text">
                  Create Position
                </Heading>
              </Link>
            </Box>
            <Box mr="14">
              <Link to="/profile" exact>
                <Heading bgGradient="linear(to-r, #9D8DF1, #B8CDF8, #1CFEBA)" bgClip="text">
                  My Positions
                </Heading>
              </Link>
            </Box>
            <Menu>
              <MenuButton>{isAuthenticated && <Avatar name={user.attributes.username} />}</MenuButton>
              <MenuList>
                <MenuItem>
                  <Link to="/profile" exact>
                    Current Positions
                  </Link>
                </MenuItem>
                <MenuItem>
                  <Link to="/updateuser" exact>
                    Update User
                  </Link>
                </MenuItem>
                <MenuItem onClick={() => logout()} disabled={isAuthenticating}>
                  Logout
                </MenuItem>
              </MenuList>
            </Menu>
          </Flex>
        </Box>
      </Flex>

      {isAuthenticated ? (
        <Switch>
          <Route path="/" exact>
            <Home />
          </Route>
          <Route path="/profile" exact>
            <Profile />
          </Route>
          <Route path="/updateuser" exact>
            <UpdateUser />
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
