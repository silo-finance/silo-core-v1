// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../PriceProvider.sol";
import "../../interfaces/IPriceProvidersRepository.sol";

/// @title ForwarderPriceProvider
/// @notice ForwarderPriceProvider is used to register the price of one token as the price source for another token.
///     For example, wrapped token price is equal to underlying token price, because it can be wrapped or
///     unwrapped with 1:1 ratio any time.
/// @custom:security-contact security@silo.finance
contract ForwarderPriceProvider is PriceProvider {
    /// @dev Token to get price, does not have pool => token that has price provider, used as the price source.
    mapping(address => address) public priceSourceAssets;

    event AssetRegistered(address indexed asset, address indexed priceSourceAsset);
    event AssetRemoved(address indexed asset);

    /// @dev Revert when price source for an asset does not exist.
    error AssetNotSupported();

    /// @dev Asset can't be it's own price source asset.
    error AssetEqualToSource();

    /// @dev Revert when price source is registered in `ForwarderPriceProvider` to prevent circular dependency.
    error DoubleForwardingIsNotAllowed();

    /// @dev Revert when price source asset does not have price in `PriceProvidersRepository`.
    error PriceSourceIsNotReady();

    /// @dev Revert `removeAsset` when `ForwarderPriceProvider` is registered as the price provider for an asset.
    error RemovingAssetWhenRegisteredInRepository();

    constructor(IPriceProvidersRepository _priceProvidersRepository) PriceProvider(_priceProvidersRepository) {}

    /// @inheritdoc IPriceProvider
    function getPrice(address _asset) public view virtual override returns (uint256) {
        address priceSourceAsset = priceSourceAssets[_asset];

        if (priceSourceAsset == address(0)) revert AssetNotSupported();

        return priceProvidersRepository.getPrice(priceSourceAsset);
    }

    /// @notice Register `_asset` price as the price of `_priceSourceAsset`
    /// @dev We don't allow price source asset to be registered in `ForwarderPriceProvider` to
    ///     prevent circular dependency. If the price source asset has price forwarded too, use the
    ///     original source instead. Does not revert for duplicate calls with the same arguments.
    /// @param _asset address, can be already registered in `ForwarderPriceProvider`
    /// @param _priceSourceAsset address, it's price must be available in `PriceProvidersRepository`
    function setupAsset(address _asset, address _priceSourceAsset) external virtual onlyManager {
        if (_asset == _priceSourceAsset) revert AssetEqualToSource();
        if (priceSourceAssets[_priceSourceAsset] != address(0)) revert DoubleForwardingIsNotAllowed();
        if (!priceProvidersRepository.providersReadyForAsset(_priceSourceAsset)) revert PriceSourceIsNotReady();

        priceSourceAssets[_asset] = _priceSourceAsset;

        emit AssetRegistered(_asset, _priceSourceAsset);
    }

    /// @notice Removes asset from this price provider. `ForwarderPriceProvider` must not be registered
    ///     as the price provider for an `_asset` in `PriceProvidersRepository`.
    /// @param _asset address
    function removeAsset(address _asset) external virtual onlyManager {
        if (address(priceProvidersRepository.priceProviders(_asset)) == address(this)) {
            revert RemovingAssetWhenRegisteredInRepository();
        }

        priceSourceAssets[_asset] = address(0);
        emit AssetRemoved(_asset);
    }

    /// @notice Returns true, if asset has other token price as the price source
    /// @param _asset address
    function assetSupported(address _asset) public view virtual override returns (bool) {
        return priceSourceAssets[_asset] != address(0);
    }
}
