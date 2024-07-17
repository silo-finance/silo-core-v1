// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../_common/CurveLPTokensDataTypes.sol";

/// @notice Curve registry extension
interface ICurveRegistriesPoolsManagement {
    /// @dev  Emitted when a pool has been added to the handler
    event PoolAdded(address indexed _pool);
    /// @dev  Emitted when a pool has been removed from the handler
    event PoolRemoved(address indexed _pool);

    /// @notice Add pools to the handler
    /// @param _pools A list of pools to be added
    function addPools(Pool[] calldata _pools) external;

    /// @notice Remove pools to the handler
    /// @param _pools A list of pools to be removed
    function removePools(address[] calldata _pools) external;
}
