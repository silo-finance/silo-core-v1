// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/utils/Manageable.sol";

contract ManageableHarness is Manageable {
    address private _owner;
    constructor () Manageable(msg.sender) {
        _owner == msg.sender;
    }

    function owner() public view override returns (address) {
        return _owner;
    }
}
