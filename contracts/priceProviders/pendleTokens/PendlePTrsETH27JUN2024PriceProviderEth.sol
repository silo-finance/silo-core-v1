// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendlePTrsETH27JUN2024PriceProviderEth is PendleTwoHopPriceProvider {
    address public constant RSETH = 0xA1290d69c65A6Fe4DF752f95823fae25cB99e5A7;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x66a1096C6366b2529274dF4f5D8247827fe4CEA8, // PT Oracle
        1800, // twap duration
        0x4f43c77872Db6BA177c270986CD30c3381AF37Ee, // PT Market
        _priceProvidersRepository,
        0xB05cABCd99cf9a73b19805edefC5f67CA5d1895E, // PT Token
        "PT-rsETH-27JUN2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = RSETH;
    }
}
