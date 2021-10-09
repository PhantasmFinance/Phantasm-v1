import { Box, Text, Heading } from "@chakra-ui/layout";
import { Cards } from "./Cards";
import { Dropdown } from "./Dropdown";
import { MainCard } from "./MainCard";

export const Home = () => {
  return (
    <Box>
      <Dropdown />
      <MainCard />
      <Heading mt={4}>Deposits</Heading>
      <Cards />
    </Box>
  );
};
