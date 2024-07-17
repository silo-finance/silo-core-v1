// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleEzETHPriceProvider.sol";

contract PendlePTEzETH26SEP2024PriceProviderArb is PendleEzETHPriceProvider {
    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0x35f3dB08a6e9cB4391348b0B404F493E7ae264c0, // PT Market
        _priceProvidersRepository,
        0x2CCFce9bE49465CC6f947b5F6aC9383673733Da9, // PT Token
        "PT-ezETH-26SEP2024" // PT token symbol
    ) {}

    function ezETH() public pure override returns (address asset) {
        asset = 0x2416092f143378750bb29b79eD961ab195CcEea5;
    }
}
