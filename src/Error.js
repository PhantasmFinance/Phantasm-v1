import { Alert, AlertIcon, Box, AlertTitle, AlertDescription, CloseButton } from "@chakra-ui/react";

export const ErrorBox = ({ title, message }) => {
  return (
    <Alert status="error">
      <AlertIcon />
      <Box flex="1">
        <AlertTitle>{title}</AlertTitle>
        <AlertDescription display="block">{message}</AlertDescription>
      </Box>
      <CloseButton position="absolute" right="8px" top="8px" />
    </Alert>
  );
};
