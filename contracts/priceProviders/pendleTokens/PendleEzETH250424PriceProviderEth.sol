// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleEzETHPriceProvider.sol";

contract PendleEzETH250424PriceProviderEth is PendleEzETHPriceProvider {
    address public constant EZETH = 0xbf5495Efe5DB9ce00f80364C8B423567e58d2110;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x66a1096C6366b2529274dF4f5D8247827fe4CEA8, // PT Oracle
        1800, // twap duration
        0xDe715330043799D7a80249660d1e6b61eB3713B3, // PT Market
        _priceProvidersRepository,
        0xeEE8aED1957ca1545a0508AfB51b53cCA7e3c0d1, // PT Token
        "PT-ezETH-25APR2024" // PT token symbol
    ) {}

    function ezETH() public pure override returns (address asset) {
        asset = EZETH;
    }
}
