// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../liquidation/magicians/interfaces/IMagician.sol";
import "../lib/RevertBytes.sol";

contract PayableMagicianWrapperMock is IMagician {
    using RevertBytes for bytes;

    address public magician;

    error EmptyAddress();

    constructor(address _magician) {
        if (_magician == address(0)) revert EmptyAddress();

        magician = _magician;
    }

    receive() external payable {
        // we accept ETH for `towardsNative` function that may convert an `_asset` into ETH
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address tokenOut, uint256 amountOut) {
        bytes memory result = _sefeDelegateCall(
            magician,
            abi.encodeCall(IMagician.towardsNative, (_asset, _amount)),
            "towardsNativeFailed"
        );

        (tokenOut, amountOut) = abi.decode(result, (address, uint256));
    }

    /// @inheritdoc IMagician
    function towardsAsset(address _asset, uint256 _amount) external returns (address tokenOut, uint256 amountOut) {
        bytes memory result = _sefeDelegateCall(
            magician,
            abi.encodeCall(IMagician.towardsAsset, (_asset, _amount)),
            "towardsAssetFailed"
        );

        (tokenOut, amountOut) = abi.decode(result, (address, uint256));
    }

    function _sefeDelegateCall(
        address _target,
        bytes memory _callData,
        string memory _mgs
    )
        internal
        returns (bytes memory data)
    {
        bool success;
        // solhint-disable-next-line avoid-low-level-calls
        (success, data) = address(_target).delegatecall(_callData);
        if (!success || data.length == 0) data.revertBytes(_mgs);
    }
}
