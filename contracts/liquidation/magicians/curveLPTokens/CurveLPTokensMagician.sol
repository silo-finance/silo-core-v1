// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../interfaces/ICurvePoolLike.sol";
import "../interfaces/ICurveLPTokensPriceProviderLike.sol";
import "../interfaces/IMagician.sol";
import "../../../lib/Ping.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";
import "../../../interfaces/IPriceProvider.sol";
import "../../../priceProviders/curveLPTokens/interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "../../../priceProviders/curveLPTokens/_common/CurveLPTokensDataTypes.sol";
import "../../../priceProviders/IERC20LikeV2.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
abstract contract CurveLPTokensMagician is IMagician {
    /// @dev Detail of the pool underlying coin required for the liquidation
    struct PoolCoinDetails {
        address coin;
        uint8 index; // an index of the coin in the pool
    }

    /// @dev Max number of coins in the Curve protocol
    int128 constant public MAX_COINS = 8;

    /// @notice Curve LP Tokens details fetchers repository
    // solhint-disable-next-line var-name-mixedcase
    ICurveLPTokensDetailsFetchersRepository public immutable FETCHERS_REPO;
    /// @dev Price providers repository quote token
    // solhint-disable-next-line var-name-mixedcase
    address public immutable QUOTE_TOKEN;

    // Curve LP Token => coin and an index
    mapping(address => PoolCoinDetails) public poolCoins;
    // Curve LP Token => pool
    mapping(address => address) public pools;

    /// @dev Revert if we are not able to get LP Token pool details from the price provider
    error InvalidOrNotSupportedLPToken();
    /// @dev Revert on a `swapAmountOut` call as it in unsupported 
    error Unsupported();
    /// @dev Revert on a false sanity check with `Ping` library
    error InvalidFetchersRepository();
    /// @dev Revert if we are not able to get the pool coins by provided curve LP token
    error InvalidCurvePriceProviderLPTokenPair();

    event Cached(address pool, address coin);

    constructor(
        ICurveLPTokensDetailsFetchersRepository _fetcherRepository,
        IPriceProvidersRepository _priceProvidersRepository
    ) {
        if (!Ping.pong(_fetcherRepository.curveLPTokensFetchersRepositoryPing)) {
            revert InvalidFetchersRepository();
        }

        FETCHERS_REPO = _fetcherRepository;
        QUOTE_TOKEN = _priceProvidersRepository.quoteToken();
    }

    /// @dev As Curve LP Tokens can be collateral-only assets we skip the implementation of this function
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _getCurvePoolUnderlyingCoin(address[] memory _coins) internal virtual view returns (address, uint256) {
        if (_coins.length == 0) revert InvalidCurvePriceProviderLPTokenPair();

        // if one of the pool underlying coins is the same as quote token
        // we must return it. The operation will be similar to swap.
        // Otherwise we need to unwrap LP token, so we return _coins[0] and an index 0
        for (uint256 i; i < _coins.length;) {
            if (QUOTE_TOKEN == _coins[i]) {
                return (QUOTE_TOKEN, i);
            }

            // Because of the condition, `i < coins.length` overflow is impossible
            unchecked { i++; }
        }

        uint256 zeroIndex = 0;
        return (_coins[0], zeroIndex);
    }

    function _getPoolAndCoin(address _asset) internal virtual returns (address pool, address coin) {
        pool = pools[_asset];

        if (pool != address(0)) {
            return (pool, poolCoins[_asset].coin);
        }

        bytes memory data; // We'll use it as an `input` and `return` data
        LPTokenDetails memory poolDetails;

        (poolDetails, data) = FETCHERS_REPO.getLPTokenDetails(_asset, data);

        if (poolDetails.pool.addr == address(0) || poolDetails.coins.length == 0) {
            revert InvalidOrNotSupportedLPToken();
        }
        
        uint256 index;
        pool = poolDetails.pool.addr;
        (coin, index) = _getCurvePoolUnderlyingCoin(poolDetails.coins);

        pools[_asset] = pool;
        poolCoins[_asset] = PoolCoinDetails({ coin: coin, index: uint8(index)});
        
        emit Cached(pool, coin);
    }
}
