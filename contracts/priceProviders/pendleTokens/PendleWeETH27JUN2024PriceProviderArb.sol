// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendleWeETH27JUN2024PriceProviderArb is PendleTwoHopPriceProvider {
    address public constant WEETH = 0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0x952083cde7aaa11AB8449057F7de23A970AA8472, // PT Market
        _priceProvidersRepository,
        0x1c27Ad8a19Ba026ADaBD615F6Bc77158130cfBE4, // PT Token
        "PT-weETH-27JUN2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = WEETH;
    }
}
