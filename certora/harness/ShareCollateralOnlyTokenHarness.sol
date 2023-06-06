// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/utils/ShareCollateralToken.sol";

contract ShareCollateralOnlyTokenHarness is ShareCollateralToken {
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
    ) ShareCollateralToken(_name, _symbol, _silo, _asset) {}
}
