// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PriceProvider.sol";
import "./../lib/TokenHelper.sol";

/// @title IndividualPriceProvider
/// @notice IndividualPriceProvider
/// @custom:security-contact security@silo.finance
abstract contract IndividualPriceProvider is PriceProvider {
    // solhint-disable-next-line var-name-mixedcase
    address public immutable ASSET;

    error InvalidAssetAddress();

    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        address _asset,
        string memory _symbol
    ) PriceProvider(_priceProvidersRepository) {
        if (keccak256(abi.encode(TokenHelper.symbol(_asset))) != keccak256(abi.encode(_symbol))) {
            revert InvalidAssetAddress();
        }

        ASSET = _asset;
    }

    /// @notice Only ASSET token is supported, false otherwise.
    /// @param _asset address of an asset
    function assetSupported(address _asset) public view virtual override returns (bool) {
        return _asset == ASSET;
    }
}
