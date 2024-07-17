// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../interfaces/IPriceProvider.sol";

/// @title Price Provider ping feature
abstract contract PriceProviderPing is IPriceProvider {
    /// @inheritdoc IPriceProvider
    function priceProviderPing() external pure returns (bytes4) {
        return this.priceProviderPing.selector;
    }
}
