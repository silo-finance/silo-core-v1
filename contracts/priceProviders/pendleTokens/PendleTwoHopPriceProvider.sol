// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendlePriceProvider.sol";

abstract contract PendleTwoHopPriceProvider is PendlePriceProvider {
    function getPrice(address _asset) public view virtual returns (uint256 price) {
        if (!assetSupported(_asset)) revert AssetNotSupported();

        // Pendle PT-...-.../<underlying> conversion rate
        uint256 ratePTtoUndelying = getPtToSyRate(twapDuration);

        // <underlying>/ETH conversion rate
        uint256 rateUnderlyingToETH = priceProvidersRepository.getPrice(ptUnderlyingToken());

        price = ratePTtoUndelying * rateUnderlyingToETH;
        unchecked { price = price / 1e18; }

        // Zero price is unacceptable
        if (price == 0) revert ZeroPrice();
    }

    function ptUnderlyingToken() public pure virtual returns (address asset) {}
}
