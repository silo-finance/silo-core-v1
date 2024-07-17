// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendlePTWeETH26SEP2024PriceProviderArb is PendleTwoHopPriceProvider {
    address public constant WEETH = 0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0xf9F9779d8fF604732EBA9AD345E6A27EF5c2a9d6, // PT Market
        _priceProvidersRepository,
        0xb8b0a120F6A68Dd06209619F62429fB1a8e92feC, // PT Token
        "PT-weETH-26SEP2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = WEETH;
    }
}
