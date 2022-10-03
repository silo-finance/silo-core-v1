// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../interfaces/ISilo.sol";

contract SimpleLiquidator {
    error LiquidationAmountTooSmall(uint256);

    function executeLiquidation(address _user, ISilo _silo) external {
        address[] memory users = new address[](1);
        users[0] = _user;
        _silo.flashLiquidate(users, "");
    }

    function siloLiquidationCallback(
        address _user,
        address[] calldata _assets,
        uint256[] calldata /* _receivedCollaterals */,
        uint256[] calldata _shareAmountsToRepay,
        bytes memory /* _flashReceiverData */
    ) external {
        ISilo silo = ISilo(msg.sender);

        for (uint256 i = 0; i < _assets.length; i++) {
            if (_shareAmountsToRepay[i] == 0) continue;

            IERC20 asset = IERC20(_assets[i]);
            uint256 amount = _shareAmountsToRepay[i];

            // solhint-disable-next-line
            try asset.transferFrom(tx.origin, address(this), amount) {
            } catch {
                revert LiquidationAmountTooSmall(amount);
            }

            asset.approve(address(silo), amount);
            silo.repayFor(_assets[i], _user, amount);
        }
    }
}
