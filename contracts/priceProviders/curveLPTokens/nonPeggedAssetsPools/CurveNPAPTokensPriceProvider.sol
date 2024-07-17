// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveLPTokensNPAPBaseCache.sol";
import "../interfaces/ICurvePoolNonPeggedAssetsLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "../interfaces/ICurveLPTokensPriceProvider.sol";
import "../../_common/PriceProviderPing.sol";
import "../../_common/PriceProvidersRepositoryQuoteToken.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @title Curve non-pegged pools tokens price provider
/// @dev NPAP - non-pegged assets pools
contract CurveNPAPTokensPriceProvider is
    CurveLPTokensNPAPBaseCache,
    PriceProvidersRepositoryQuoteToken,
    PriceProviderPing,
    ICurveLPTokensPriceProvider
{
    /// @dev Constructor is required for indirect CurveLPTokensPriceProvider initialization.
    /// Arguments for CurveLPTokensPriceProvider initialization are given in the
    /// modifier-style in the derived constructor. There are no requirements during
    /// CurveNPAPTokensPriceProvider deployment, so the constructor body should be empty.
    constructor(
        IPriceProvidersRepository _providersRepository,
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        address _nullAddr,
        address _nativeWrappedAddr
    )
        PriceProvidersRepositoryManager(_providersRepository)
        CurveLPTokenDetailsBaseCache(_fetchersRepository, _nullAddr, _nativeWrappedAddr)
    {
        // The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @inheritdoc ICurveLPTokensPriceProvider
    function setupAsset(address _lpToken) external virtual onlyManager {
        _setUpAssetAndEnsureItIsSupported(_lpToken);
    }

    /// @inheritdoc ICurveLPTokensPriceProvider
    function setupAssets(address[] calldata _lpTokens) external virtual onlyManager {
        uint256 i = 0;

        while(i < _lpTokens.length) {
            _setUpAssetAndEnsureItIsSupported(_lpTokens[i]);

            // Ignoring overflow check as it is impossible
            // to have more than 2 ** 256 - 1 LP Tokens for initialization.
            unchecked { i++; }
        }
    }

    /// @inheritdoc IPriceProvider
    function assetSupported(address _lpToken) external virtual view returns (bool) {
        return lpTokenPool[_lpToken].addr != address(0);
    }

    /// @param _lpToken Curve LP Token address for which a price to be calculated
    /// @return Price of the `_lpToken` denominated in the price providers repository quote token
    function getPrice(address _lpToken) external virtual view returns (uint256) {
        address pool = lpTokenPool[_lpToken].addr;

        if (pool == address(0)) revert NotSupported();
        
        uint256 lpPrice = ICurvePoolNonPeggedAssetsLike(pool).lp_price();

        return _getPrice(_lpToken, lpPrice);
    }

    /// @notice Enable Curve LP token in the price provider
    /// @param _lpToken Curve LP Token address that will be enabled in the price provider
    function _setUpAssetAndEnsureItIsSupported(address _lpToken) internal virtual {
        _setupAsset(_lpToken);
        
        // Ensure that the get price function does not revert for initialized coins
        // The price providers repository should revert if the provided coin is not supported
        _priceProvidersRepository.getPrice(coins[_lpToken][0].addr);
    }

    /// @param _lpToken Curve LP Token address for which a price to be calculated
    /// @param _lpPrice Curve LP Token price received from the pool's `lp_price` function
    /// @return price of the `_lpToken` denominated in the price providers repository quote token
    function _getPrice(address _lpToken, uint256 _lpPrice) internal virtual view returns (uint256 price) {
        uint256 coinPrice = _priceProvidersRepository.getPrice(coins[_lpToken][0].addr);

        // `_lpToken` price calculation
        price = coinPrice * _lpPrice;

        // It doesn't make sense to do any math check here because if a `price` < 1e18,
        // in any case, it will return 0. Otherwise, we are fine.
        unchecked { price = price / 1e18; }

        // Zero price is unacceptable
        if (price == 0) revert ZeroPrice();
    }
}
