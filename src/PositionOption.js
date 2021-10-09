import { Radio, RadioGroup, HStack, Box, Image, Stack, Badge, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb } from "@chakra-ui/react";
import React, { useState } from "react";
import { ChevronRightIcon } from "@chakra-ui/icons";

export const PositionOption = ({}) => {
  const [position, setPosition] = useState("long");

  return (
    <Center mt={3}>
      <RadioGroup onChange={setPosition} value={position}>
        <Stack spacing={4} direction="row">
          <Radio value="long" colorScheme="green">
            Long
          </Radio>
          <Radio value="short" colorScheme="green">
            Short
          </Radio>
        </Stack>
      </RadioGroup>
    </Center>
  );
};
