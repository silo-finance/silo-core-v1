// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../../lib/Ping.sol";
import "../../_common/PriceProvidersRepositoryManager.sol";
import "../../../interfaces/IPriceProvider.sol";
import "../interfaces/ICurveRegistryLike.sol";
import "../interfaces/ICurveLPTokensDetailsFetchersRepository.sol";
import "./CurveLPTokensDataTypes.sol";

abstract contract CurveLPTokenDetailsBaseCache {
    /// @notice Curve LP Tokens details fetchers repository
    // solhint-disable-next-line var-name-mixedcase
    ICurveLPTokensDetailsFetchersRepository internal immutable _FETCHERS_REPO;
    /// @notice A null address that the Curve pool use to describe ether coin
    // solhint-disable-next-line var-name-mixedcase
    address internal immutable _NULL_ADDRESS;
    /// @notice wETH address
    // solhint-disable-next-line var-name-mixedcase
    address internal immutable _NATIVE_WRAPPED_ADDRESS;
    /// @notice Minimal number of coins in the valid pool
    uint8 internal constant _MIN_COINS = 2;

    /// @dev LP Token address => pool coins
    mapping(address => PoolCoin[]) public coins;
    /// @dev LP Token address => pool details
    mapping(address => Pool) public lpTokenPool;

    /// Revert if this price provider does not support an asset
    error NotSupported();
    /// Revert on a false sanity check with `Ping` library
    error InvalidFetchersRepository();
    /// Revert if a pool is not found for provided Curve LP Token
    error PoolForLPTokenNotFound();
    /// Revert if a number of coins in the initialized pool < `_MIN_COINS`
    error InvalidNumberOfCoinsInPool();
    /// Revert if Curve LP Token is already initialized in the price provider
    error TokenAlreadyInitialized();
    /// Revert if wETH address is empty
    error EmptyWETHAddress();
    /// @dev Revert if a `getPrice` function ended-up with a zero price
    error ZeroPrice();

    /// @param _repository Curve LP Tokens details fetchers repository
    /// @param _nullAddr Null address that Curve use for a native token
    /// @param _nativeWrappedAddr Address of the wrapped native token
    constructor(
        ICurveLPTokensDetailsFetchersRepository _repository,
        address _nullAddr,
        address _nativeWrappedAddr
    ) {
        if (address(_nativeWrappedAddr) == address(0)) revert EmptyWETHAddress();

        if (!Ping.pong(_repository.curveLPTokensFetchersRepositoryPing)) {
            revert InvalidFetchersRepository();
        }

        _FETCHERS_REPO = _repository;
        _NULL_ADDRESS = _nullAddr;
        _NATIVE_WRAPPED_ADDRESS = _nativeWrappedAddr;
    }
}
