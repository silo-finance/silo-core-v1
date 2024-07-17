// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./PendleCamelotMagicianV2.sol";

contract PendlePTRsETH26SEP2024MagicianArb is PendleCamelotMagicianV2 {
    constructor() PendleCamelotMagicianV2(
        0x30c98c0139B62290E26aC2a2158AC341Dcaf1333, // PT Token
        0xED99fC8bdB8E9e7B8240f62f69609a125A0Fbf14, // PT Market
        0x4186BFC76E2E237523CBC30FD220FE055156b41F  // Underlying
    ) {}
}
