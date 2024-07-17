// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendlePTrswETH27JUN2024PriceProviderEth is PendleTwoHopPriceProvider {
    address public constant RWSETH = 0xFAe103DC9cf190eD75350761e95403b7b8aFa6c0;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x66a1096C6366b2529274dF4f5D8247827fe4CEA8, // PT Oracle
        1800, // twap duration
        0xA9355a5d306c67027C54De0e5a72df76Befa5694, // PT Market
        _priceProvidersRepository,
        0x5cb12D56F5346a016DBBA8CA90635d82e6D1bcEa, // PT Token
        "PT-rswETH-27JUN2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = RWSETH;
    }
}
