import { Button, Stack, Input, Text, Image, Center, Heading, Flex } from "@chakra-ui/react";
import { useState } from "react";
import { useMoralis } from "react-moralis";
import { ErrorBox } from "./Error";
import logo from "./assets/ghost.png";
import metamask from "./assets/images/metamask-fox.svg";
import { ChevronDownIcon } from "@chakra-ui/icons";

const SignUp = () => {
  const { signup } = useMoralis();
  const [email, setEmail] = useState();
  const [password, setPassword] = useState();

  return (
    <Stack spacing={3}>
      <Input placeholder="Enter Email" value={email} onChange={(event) => setEmail(event.currentTarget.value)} />
      <Input placeholder="Enter Password" type="password" value={password} onChange={(event) => setPassword(event.currentTarget.value)} />
      <Button onClick={() => signup(email, password, email)}>Sign Up</Button>
    </Stack>
  );
};

const Login = () => {
  const { login } = useMoralis();
  const [email, setEmail] = useState();
  const [password, setPassword] = useState();

  return (
    <Stack spacing={3}>
      <Input placeholder="Enter Email" value={email} onChange={(event) => setEmail(event.currentTarget.value)} />
      <Input placeholder="Enter Password" type="password" value={password} onChange={(event) => setPassword(event.currentTarget.value)} />
      <Button onClick={() => login(email, password)}>Login</Button>
    </Stack>
  );
};

export const Auth = () => {
  const { authenticate, isAuthenticating, authError } = useMoralis();

  return (
    <Stack spacing={6}>
      {authError && <ErrorBox title="Authentication Has Failed!" message={authError.message} />}
      <Center>
        <Heading as="h1" size="3xl">
          Phantasm Finance
        </Heading>
      </Center>
      <Center>
        <Image src={logo} boxSize="160px" />
      </Center>
      <Center mb="60px">
        <Heading>Defi Doesn't Have To Be Scary</Heading>
      </Center>
      <Center>
        <Button isLoading={isAuthenticating} onClick={() => authenticate()} bgGradient="linear(to-r, #9D8DF1, #B8CDF8, #1CFEBA)" boxShadow="lg" size="l" p={3} colorScheme="blue" fontSize="26px" fontWeight="bold" w="400px" maxWidth="40ch" borderRadius={30}>
          <Image src={metamask} boxSize={24} mr="16px" />
          Click To Enter
        </Button>
      </Center>
      <Center>
        <Flex>
          <ChevronDownIcon boxSize={20} />
          <Heading mt={4}>Learn More</Heading>
          <ChevronDownIcon boxSize={20} />
        </Flex>
      </Center>
      <Text textAlign="center">
        <em>or</em>
      </Text>
      <SignUp />
      <Text textAlign="center">
        <em>or</em>
      </Text>
      <Login />
    </Stack>
  );
};
