// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./CurveRegistriesBaseFetcher.sol";
import "../_common/CurveLPTokensDataTypes.sol";
import "../interfaces/ICurveRegistriesPoolsManagement.sol";
import "../interfaces/ICurveCryptoSwapRegistryLike.sol";

/// @title Curve registries pools management
abstract contract CurveRegistriesPoolsManagement is ICurveRegistriesPoolsManagement, CurveRegistriesBaseFetcher {
    /// @dev Storage struct with a registered pool details
    struct RegisteredPool {
        bool isRegistered; // `true` if a pool is registered in the fetcher
        bool isMeta; // `true` if a pools is meta pool. Storing it as in some registries
        // this information is missed, and it is not possible to retrieve it
    }

    /// pool address => registered pool details
    mapping(address => RegisteredPool) public registeredPools;

    /// Reverts if a pool address is empty
    error EmptyPoolAddress();
    /// Reverts if a pool is already registered in the fetcher
    error AlreadyRegistered(address pool);
    /// Reverts if a pool is not registered
    error PoolIsNotRegistered(address pool);
    /// Reverts if a pool is not found in the registry
    error CantResolvePoolInRegistry();

    /// @param _pools A list of pools with details for a fetcher initialization
    constructor(Pool[] memory _pools) {
        _addPools(_pools);
    }

    /// @inheritdoc ICurveRegistriesPoolsManagement
    function addPools(Pool[] calldata _pools) external virtual onlyManager {
        _addPools(_pools);
    }

    /// @inheritdoc ICurveRegistriesPoolsManagement
    function removePools(address[] calldata _pools) external virtual onlyManager {
        uint256 i = 0;

        while (i < _pools.length) {
            address pool = _pools[i];

            if (!registeredPools[pool].isRegistered) revert PoolIsNotRegistered(pool);

            delete registeredPools[pool];

            emit PoolRemoved(pool);

            // Because of the condition `i < _pools.length` we can ignore overflow check
            unchecked { i++; }
        }
    }

    /// @notice Add pools to the fetcher
    /// @param _pools A list of pools to be added
    function _addPools(Pool[] memory _pools) internal {
        uint256 i = 0;
        ICurveCryptoSwapRegistryLike registry = ICurveCryptoSwapRegistryLike(registry);

        while (i < _pools.length) {
            Pool memory pool = _pools[i];

            if (pool.addr == address(0)) revert EmptyPoolAddress();
            if (registeredPools[pool.addr].isRegistered) revert AlreadyRegistered(pool.addr);

            address lpToken = registry.get_lp_token(pool.addr);

            if (lpToken == address(0)) revert CantResolvePoolInRegistry();

            registeredPools[pool.addr] = RegisteredPool({
                isRegistered: true,
                isMeta: pool.isMeta
            });

            emit PoolAdded(pool.addr);

            // Because of the condition `i < _pools.length` we can ignore overflow check
            unchecked { i++; }
        }
    }
}
