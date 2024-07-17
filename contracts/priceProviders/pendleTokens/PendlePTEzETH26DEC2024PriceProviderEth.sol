// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleEzETHPriceProvider.sol";

contract PendlePTEzETH26DEC2024PriceProviderEth is PendleEzETHPriceProvider {
    address public constant EZETH = 0xbf5495Efe5DB9ce00f80364C8B423567e58d2110;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x66a1096C6366b2529274dF4f5D8247827fe4CEA8, // PT Oracle
        1800, // twap duration
        0xD8F12bCDE578c653014F27379a6114F67F0e445f, // PT Market
        _priceProvidersRepository,
        0xf7906F274c174A52d444175729E3fa98f9bde285, // PT Token
        "PT-ezETH-26DEC2024" // PT token symbol
    ) {}

    function ezETH() public pure override returns (address asset) {
        asset = EZETH;
    }
}
