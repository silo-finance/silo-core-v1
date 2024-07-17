// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./PendleCamelotMagicianV2.sol";

contract PendlePTEzETH26SEP2024MagicianArb is PendleCamelotMagicianV2 {
    constructor() PendleCamelotMagicianV2(
        0x2CCFce9bE49465CC6f947b5F6aC9383673733Da9, // PT Token
        0x35f3dB08a6e9cB4391348b0B404F493E7ae264c0, // PT Market
        0x2416092f143378750bb29b79eD961ab195CcEea5  // Underlying
    ) {}
}
