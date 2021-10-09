import { Box, Input, Text, Stack, Button } from "@chakra-ui/react";
import { useState } from "react";
import { useMoralis } from "react-moralis";
import { ErrorBox } from "./Error";

export const Profile = () => {
  const { user, setUserData, userError, isUserUpdating } = useMoralis();

  const [username, setUsername] = useState(user.attributes.username);
  const [email, setEmail] = useState(user.attributes.email);
  const [password, setPassword] = useState("");

  const handleSave = () => {
    setUserData({
      username,
      email,
      password: password === "" ? undefined : password,
    });
  };

  return (
    <Box>
      <Stack spacing={3}>
        {userError && <ErrorBox title="User Change Failed" message={userError.message} />}
        <Box>
          <Text>Username</Text>
          <Input value={username} onChange={(event) => setUsername(event.currentTarget.value)} />
        </Box>
        <Box>
          <Text>Email</Text>
          <Input value={email} onChange={(event) => setEmail(event.currentTarget.value)} />
        </Box>
        <Box>
          <Text>Password</Text>
          <Input type="password" value={password} onChange={(event) => setPassword(event.currentTarget.value)} />
        </Box>
        <Button onClick={handleSave} isLoading={isUserUpdating}>
          Save Changes
        </Button>
      </Stack>
    </Box>
  );
};
