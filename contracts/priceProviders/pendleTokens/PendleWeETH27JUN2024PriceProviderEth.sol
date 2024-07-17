// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendleWeETH27JUN2024PriceProviderEth is PendleTwoHopPriceProvider {
    address public constant WEETH = 0xCd5fE23C85820F7B72D0926FC9b05b43E359b7ee;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x66a1096C6366b2529274dF4f5D8247827fe4CEA8, // PT Oracle
        1800, // twap duration
        0xF32e58F92e60f4b0A37A69b95d642A471365EAe8, // PT Market
        _priceProvidersRepository,
        0xc69Ad9baB1dEE23F4605a82b3354F8E40d1E5966, // PT Token
        "PT-weETH-27JUN2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = WEETH;
    }
}
