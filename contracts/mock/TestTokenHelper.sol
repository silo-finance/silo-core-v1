// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../lib/TokenHelper.sol";

interface ERC20Bytes32Symbol {
    function symbol() external view returns(bytes32);
}

/// @dev this is MOCK contract - DO NOT USE IT!
contract TestTokenHelper {
    function symbol(address _token) external view returns (string memory) {
        return TokenHelper.symbol(_token);
    }
}
