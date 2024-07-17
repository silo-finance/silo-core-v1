// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface IMarket {
    struct Price {
        uint256 value;
    }

    function getMarketPrice(
        uint256 marketId
    )
        external
        view
        returns (Price memory);
}
