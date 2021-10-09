import { Button, Stack, Input, Text } from "@chakra-ui/react";
import { useState } from "react";
import { useMoralis } from "react-moralis";
import { ErrorBox } from "./Error";

const SignUp = () => {
  const { signup } = useMoralis();
  const [email, setEmail] = useState();
  const [password, setPassword] = useState();

  return (
    <Stack spacing={3}>
      <Input
        placeholder="Enter Email"
        value={email}
        onChange={(event) => setEmail(event.currentTarget.value)}
      />
      <Input
        placeholder="Enter Password"
        type="password"
        value={password}
        onChange={(event) => setPassword(event.currentTarget.value)}
      />
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
      <Input
        placeholder="Enter Email"
        value={email}
        onChange={(event) => setEmail(event.currentTarget.value)}
      />
      <Input
        placeholder="Enter Password"
        type="password"
        value={password}
        onChange={(event) => setPassword(event.currentTarget.value)}
      />
      <Button onClick={() => login(email, password)}>Login</Button>
    </Stack>
  );
};

export const Auth = () => {
  const { authenticate, isAuthenticating, authError } = useMoralis();

  return (
    <Stack spacing={6}>
      {authError && (
        <ErrorBox
          title="Authentication Has Failed!"
          message={authError.message}
        />
      )}

      <Button isLoading={isAuthenticating} onClick={() => authenticate()}>
        Authenticate With Metamask
      </Button>
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
