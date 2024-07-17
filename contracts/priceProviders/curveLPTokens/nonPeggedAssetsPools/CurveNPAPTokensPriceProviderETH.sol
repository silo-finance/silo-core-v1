// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveLPTokensNPAPBaseCache.sol";
import "../interfaces/ICurvePoolNonPeggedAssetsLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "../interfaces/ICurveLPTokensPriceProvider.sol";
import "../../_common/PriceProviderPing.sol";
import "../../_common/PriceProvidersRepositoryQuoteToken.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";
import "./CurveNPAPTokensPriceProvider.sol";

/// @title Curve non-pegged pools tokens price provider for ethereum network
/// @notice We have a particular case with the tricrypto2 pool in the Ethereum network,
/// as it is without the lp_rice() function, and it is implemented in the separate smart contract.
/// @dev NPAP - non-pegged assets pools
contract CurveNPAPTokensPriceProviderETH is CurveNPAPTokensPriceProvider {
    /// @dev tricrypto2 (USDT/wBTC/ETH) LP Token (Ethereum network)
    address constant public TRICRYPTO2_LP_TOKEN = 0xc4AD29ba4B3c580e6D59105FFf484999997675Ff;
    /// @dev tricrypto2 smart contract to provide LP token price (Ethereum network)
    address constant public TRICRYPTO2_LP_PRICE = 0xE8b2989276E2Ca8FDEA2268E3551b2b4B2418950;

    /// @dev Constructor is required for indirect CurveLPTokensPriceProvider initialization.
    /// Arguments for CurveLPTokensPriceProvider initialization are given in the
    /// modifier-style in the derived constructor. There are no requirements during
    /// CurveNPAPTokensPriceProviderETH deployment, so the constructor body should be empty.
    constructor(
        IPriceProvidersRepository _providersRepository,
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        address _nullAddr,
        address _nativeWrappedAddr
    )
        CurveNPAPTokensPriceProvider(
            _providersRepository,
            _fetchersRepository,
            _nullAddr,
            _nativeWrappedAddr
        )
    {
        // The code will not compile without it. So, we need to keep an empty constructor.
    }

    /// @param _lpToken Curve LP Token address for which a price to be calculated
    /// @return Price of the `_lpToken` denominated in the price providers repository quote token
    function getPrice(address _lpToken) external override view returns (uint256) {
        address pool = lpTokenPool[_lpToken].addr;

        if (pool == address(0)) revert NotSupported();

        // We have a particular case for the tricrypto2 pool, as originally, it didn't support
        // the `lp_price` function. Because of it, function was implemented in a separate smart contract.
        address provider = _lpToken == TRICRYPTO2_LP_TOKEN ? TRICRYPTO2_LP_PRICE : pool;
        uint256 lpPrice = ICurvePoolNonPeggedAssetsLike(provider).lp_price();

        return _getPrice(_lpToken, lpPrice);
    }
}
