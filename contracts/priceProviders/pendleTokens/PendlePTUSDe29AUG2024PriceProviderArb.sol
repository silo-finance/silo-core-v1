// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendleTwoHopPriceProvider.sol";

contract PendlePTUSDe29AUG2024PriceProviderArb is PendleTwoHopPriceProvider {
    address public constant USDE = 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34;

    constructor(IPriceProvidersRepository _priceProvidersRepository) PendlePriceProvider(
        0x1Fd95db7B7C0067De8D45C0cb35D59796adfD187, // PT Oracle
        1800, // twap duration
        0x2Dfaf9a5E4F293BceedE49f2dBa29aACDD88E0C4, // PT Market
        _priceProvidersRepository,
        0xad853EB4fB3Fe4a66CdFCD7b75922a0494955292, // PT Token
        "PT-USDe-29AUG2024" // PT token symbol
    ) {}

    function ptUnderlyingToken() public pure override returns (address asset) {
        asset = USDE;
    }
}
