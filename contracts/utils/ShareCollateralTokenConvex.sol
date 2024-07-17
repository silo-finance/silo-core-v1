// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./ShareCollateralTokenV2.sol";
import "../interfaces/IConvexSiloWrapper.sol";

/// @title ShareCollateralTokenConvex is the collateral token for ConvexSiloWrapper Silos. This token checkpoints
///     rewards before collateral tokens transfer.
/// @notice ERC20 compatible token representing collateral position in Silo
/// @custom:security-contact security@silo.finance
contract ShareCollateralTokenConvex is ShareCollateralTokenV2 {
    /// @dev Token is always deployed for specific Silo and asset
    /// @param _name token name
    /// @param _symbol token symbol
    /// @param _silo Silo address for which tokens was deployed
    /// @param _asset asset for which this tokens was deployed
    constructor (
        string memory _name,
        string memory _symbol,
        address _silo,
        address _asset
    ) ShareCollateralTokenV2(_name, _symbol, _silo, _asset) {
        // all setup is done in parent contracts, nothing to do here
    }

    function _beforeTokenTransfer(address _sender, address _recipient, uint256 _amount) internal virtual override {
        if (_isTransfer(_sender, _recipient)) {
            IConvexSiloWrapper(asset).checkpointPair(_sender, _recipient);
        }

        super._beforeTokenTransfer(_sender, _recipient, _amount);
    }
}
