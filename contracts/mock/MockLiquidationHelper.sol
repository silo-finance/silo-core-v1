// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../SiloLens.sol";
import "../interfaces/ISiloRepository.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract MockLiquidationHelper is IFlashLiquidationReceiver {
    ISiloRepository public immutable siloRepository;
    SiloLens public immutable lens;

    constructor (address _repository, address _lens) {
        siloRepository = ISiloRepository(_repository);
        lens = SiloLens(_lens);
    }

    function executeLiquidation(address[] memory _users, ISilo _silo) external {
        _silo.flashLiquidate(_users, abi.encode(0x0));
    }

    /// @dev this is working example of how to perform liquidation, this method will be called by Silo
    ///         Keep in mind, that this helper might NOT choose the best swap option.
    ///         For best results (highest earnings) you probably want to implement your own callback and maybe use some
    ///         dex aggregators.
    function siloLiquidationCallback(
        address _user,
        address[] calldata _assets,
        uint256[] calldata,
        uint256[] calldata _shareAmountsToRepaid,
        bytes memory
    ) external override {
        // repay
        for (uint256 i = 0; i < _assets.length; i++) {
            if (_shareAmountsToRepaid[i] == 0) continue;

            ISilo(msg.sender).repayFor(_assets[i], _user, _shareAmountsToRepaid[i]);
        }
    }
}
