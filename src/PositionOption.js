import { Radio, RadioGroup, HStack, Box, Image, Stack, Badge, Text, Button, useColorMode, Center, Slider, SliderTrack, SliderFilledTrack, SliderThumb } from "@chakra-ui/react";
import React, { useState } from "react";
import { ChevronRightIcon } from "@chakra-ui/icons";

export const PositionOption = ({ positionChange }) => {
  return (
    <Center mt={3}>
      <RadioGroup defaultValue="long">
        <Stack spacing={4} direction="row">
          <Radio value="long" colorScheme="green" onClick={() => positionChange("LONG")} defaultChecked>
            Long
          </Radio>
          <Radio value="short" colorScheme="green" onClick={() => positionChange("SHORT")}>
            Short
          </Radio>
        </Stack>
      </RadioGroup>
    </Center>
  );
};
