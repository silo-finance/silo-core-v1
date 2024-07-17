// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleEzETHPriceProvider.sol";

contract PendleEzETH270624PriceProviderArb is PendleEzETHPriceProvider {
    address public constant EZETH = 0x2416092f143378750bb29b79eD961ab195CcEea5;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0x5E03C94Fc5Fb2E21882000A96Df0b63d2c4312e2, // PT Market
        _priceProvidersRepository,
        0x8EA5040d423410f1fdc363379Af88e1DB5eA1C34, // PT Token
        "PT-ezETH-27JUN2024" // PT token symbol
    ) {}

    function ezETH() public pure override returns (address asset) {
        asset = EZETH;
    }
}
