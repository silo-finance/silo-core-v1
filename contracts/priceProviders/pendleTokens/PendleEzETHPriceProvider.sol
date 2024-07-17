// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendlePriceProvider.sol";

abstract contract PendleEzETHPriceProvider is PendlePriceProvider {
    function getPrice(address _asset) public view virtual returns (uint256 price) {
        if (!assetSupported(_asset)) revert AssetNotSupported();

        // Pendle PT-ezETH-..../ezETH conversion rate
        uint256 ratePRtoEZETH = getPtToSyRate(twapDuration);

        // RedStone ezETH/ETH conversion rate
        uint256 rateEZETHtoETH = priceProvidersRepository.getPrice(ezETH());

        price = ratePRtoEZETH * rateEZETHtoETH;
        unchecked { price = price / 1e18; }

        // Zero price is unacceptable
        if (price == 0) revert ZeroPrice();
    }

    function ezETH() public pure virtual returns (address asset) {}
}
