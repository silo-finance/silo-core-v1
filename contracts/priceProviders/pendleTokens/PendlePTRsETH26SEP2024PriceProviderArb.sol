// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendlePTRsETH26SEP2024PriceProviderArb is PendleTwoHopPriceProvider {
    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0xED99fC8bdB8E9e7B8240f62f69609a125A0Fbf14, // PT Market
        _priceProvidersRepository,
        0x30c98c0139B62290E26aC2a2158AC341Dcaf1333, // PT Token
        "PT-rsETH-26SEP2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = 0x4186BFC76E2E237523CBC30FD220FE055156b41F;
    }
}
