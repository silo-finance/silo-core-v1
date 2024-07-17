// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PriceProvidersRepositoryManager.sol";
import "../../interfaces/IPriceProvider.sol";

/// @title Price providers repository quote token
abstract contract PriceProvidersRepositoryQuoteToken is PriceProvidersRepositoryManager, IPriceProvider {
    /// @inheritdoc IPriceProvider
    function quoteToken() external view returns (address) {
        return _priceProvidersRepository.quoteToken();
    }
}
