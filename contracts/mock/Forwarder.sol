// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../interfaces/IFlashLiquidationReceiver.sol";
import "../interfaces/ISilo.sol";
import "../interfaces/IShareToken.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract Forwarder {
    address public debtToken;

    function siloLiquidationCallback(
        IFlashLiquidationReceiver _destination,
        address _user,
        address[] calldata _assets,
        uint256[] calldata _receivedCollaterals,
        uint256[] calldata _shareAmountsToRepaid,
        bytes memory _flashReceiverData
    ) external {
        _destination.siloLiquidationCallback(
            _user,
            _assets,
            _receivedCollaterals,
            _shareAmountsToRepaid,
            _flashReceiverData
        );
    }

    function setDebtToken(address _debtToken) external {
        debtToken = _debtToken;
    }

    function assetStorage(address) external view returns (ISilo.AssetStorage memory siloAssetStorage) {
        siloAssetStorage.debtToken = IShareToken(debtToken);
    }

    function repayFor(address, address, uint256 _amount)
        external
        pure
        returns (uint256 repaidAmount, uint256 burnedShare)
    {
        return (_amount, _amount);
    }
}
