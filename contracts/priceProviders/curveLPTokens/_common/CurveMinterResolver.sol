// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../interfaces/ICurveLPTokenMinterLike.sol";

/// @title Low level getters from the Curve LP tokens and pools
library CurveMinterResolver {
    /// @dev An encoded input for the `minter` function
    bytes constant private _MINTER_FN_INPUT = abi.encode(ICurveLPTokenMinterLike.minter.selector);

    /// @param _lpToken LP Token address
    /// @return pool address of the LP Token in the case if the token has a `minter` function
    function getMinter(address _lpToken) internal view returns (address pool) {
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory data) = _lpToken.staticcall(_MINTER_FN_INPUT);

        if (success && data.length != 0) {
            return abi.decode(data, (address));
        }
    }
}
