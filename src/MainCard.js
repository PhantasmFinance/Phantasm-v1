import { Box, Image, Stack, Badge, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb, Flex } from "@chakra-ui/react";
import React, { useState } from "react";
import { ChevronRightIcon } from "@chakra-ui/icons";
import { PositionOption } from "./PositionOption";
import { CollateralDropdown } from "./CollateralDropdown";
import { BorrowDropdown } from "./BorrowDropdown";
import { useMoralis, Moralis } from "react-moralis";

export const MainCard = ({ _asset, _protocol, _totalTokensLocked, _totalUSDLocked }) => {
  const compoundColorScheme = "green";
  const aaveColorScheme = "purple";
  const daiViaAavePool = "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E";
  const daiViaCompoundPool = "0x11B1c87983F881B3686F8b1171628357FAA30038";
  const [pool, setPool] = useState("");

  const handlePoolChange = (value) => {
    setPool(value);
  };
  const { colorMode, toggleColorMode } = useColorMode();
  const [leverageAmount, setLeverageAmount] = useState(0);
  const percentAmount = leverageAmount * 100;

  return (
    <div className="app">
      <Box rounded="20px" overflow="hidden" bg={colorMode === "dark" ? "gray.700" : "gray.200"} mt={10} mr={5} boxShadow="dark-lg">
        <Center>
          <Image src="https://s2.coinmarketcap.com/static/img/coins/200x200/4943.png" alt="Card Image" boxSize="80px" mt={5}></Image>
          <ChevronRightIcon w={8} h={8} mt={5} />
          <Image src="https://www.economywatch.com/wp-content/uploads/2021/09/logo-8.png" alt="Card Image" boxSize="80px" mt={5}></Image>
        </Center>
        <Box p={5}>
          <Stack align="center">
            <Badge variant="solid" colorMode="light" colorScheme="yellow" rounded="full" px={2}>
              Asset: {_asset}
            </Badge>
            <Badge variant="solid" colorScheme={compoundColorScheme} rounded="full" px={2}>
              Protocol: {_protocol}
            </Badge>
          </Stack>
          <Stack align="center">
            <Text as="h2" fontWeight="bold" mt={5}>
              Total Locked
              <br />
              {_totalTokensLocked}
              {_asset}
            </Text>
            <Text fontWeight="light">${_totalUSDLocked}</Text>
          </Stack>

          <CollateralDropdown />
          <BorrowDropdown />

          <PositionOption />
          <Text as="h2" fontWeight="normal" mt={5}>
            Leverage: {percentAmount}%
          </Text>
          <Slider
            aria-label="card-leverage-slider"
            defaultValue={0}
            min={0}
            max={0.6}
            step={0.05}
            mt={2}
            onChange={(val) => {
              const currentLeverageAmount = val;
              setLeverageAmount(currentLeverageAmount);
            }}
          >
            <SliderTrack bg="green.100">
              <Box position="relative" right={10} />
              <SliderFilledTrack bg={compoundColorScheme} />
            </SliderTrack>
            <SliderThumb boxSize={6} />
          </Slider>
          <Center>
            <Button variant="solid" colorScheme="green" size="sm" mt={5} boxShadow="lg">
              Enter Position
            </Button>
          </Center>
        </Box>
      </Box>
    </div>
  );
};
