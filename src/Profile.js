import { Box, Image, Heading, Stack, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb, Flex } from "@chakra-ui/react";
import React, { useState } from "react";
import { CheckIcon, CloseIcon } from "@chakra-ui/icons";
import { PositionOption } from "./PositionOption";
import { CollateralDropdown } from "./CollateralDropdown";
import { BorrowDropdown } from "./BorrowDropdown";
import { useMoralis, useMoralisWeb3Api } from "react-moralis";

export const CurrentPositions = () => {
  const { colorMode, toggleColorMode } = useColorMode();

  async function closePosition() {
    console.log("Close the position");
  }

  return (
    <div>
      <Box p={3} rounded="20px" overflow="hidden" bg={colorMode === "dark" ? "gray.700" : "gray.200"} my={10} mr={5} boxShadow="dark-lg">
        <Heading mb="20px">Current Positions</Heading>
        <Box>
          <Center>
            <Flex>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Asset
                </Text>
                <Center>
                  <Image boxSize="2rem" borderRadius="full" src="https://cryptologos.cc/logos/multi-collateral-dai-dai-logo.png"></Image>
                </Center>
              </Stack>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Long/Short
                </Text>
                <Center>
                  <Text>Long</Text>
                </Center>
              </Stack>
              <Stack mx="25px">
                <Text as="u" fontSize="xl">
                  Insulated
                </Text>
                <Center>
                  <CheckIcon />
                </Center>
              </Stack>
              <Stack mx="6px">
                <Text as="u" fontSize="xl">
                  Debt Owed
                </Text>
                <Center>
                  <Text>500</Text>
                </Center>
              </Stack>
              <Stack mx="6px">
                <Text as="u" fontSize="xl">
                  Total Collateral
                </Text>
                <Center>
                  <Text>10000</Text>
                </Center>
              </Stack>
              <Stack mx="5px">
                <Center>
                  <Text as="u" fontSize="xl">
                    Action
                  </Text>
                </Center>
                <Button variant="solid" colorScheme="green" size="sm" mt={5} boxShadow="lg" onClick={closePosition}>
                  Close Position
                </Button>
              </Stack>
            </Flex>
          </Center>
        </Box>
      </Box>
    </div>
  );
};
