// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendleRsETH27JUN2024PriceProviderArb is PendleTwoHopPriceProvider {
    address public constant RSETH = 0x4186BFC76E2E237523CBC30FD220FE055156b41F;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0x6Ae79089b2CF4be441480801bb741A531d94312b, // PT Market
        _priceProvidersRepository,
        0xAFD22F824D51Fb7EeD4778d303d4388AC644b026, // PT Token
        "PT-rsETH-27JUN2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = RSETH;
    }
}
