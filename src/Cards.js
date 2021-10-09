import { Box, Image, Stack, Badge, Flex, Spacer, Text, Button, useColorMode, Center } from "@chakra-ui/react";
import { Card } from "./Card";
import React, { useState } from "react";

export const Cards = () => {
  const compoundColorScheme = "green";
  const aaveColorScheme = "purple";
  const daiViaAavePool = "0x6D97eA6e14D35e10b50df9475e9EFaAd1982065E";
  const daiViaCompoundPool = "0x11B1c87983F881B3686F8b1171628357FAA30038";
  const [pool, setPool] = useState("");

  const handlePoolChange = (value) => {
    setPool(value);
  };
  const { colorMode, toggleColorMode } = useColorMode();

  return (
    <div>
      <Flex>
        <Card _asset="DAI" _protocol="Compound" _totalTokensLocked="100,000" _totalUSDLocked="98,827" />
        <Card _asset="DAI" _protocol="Compound" _totalTokensLocked="100,000" _totalUSDLocked="98,827" />
        <Card _asset="DAI" _protocol="Compound" _totalTokensLocked="100,000" _totalUSDLocked="98,827" />
      </Flex>
    </div>
  );
};
