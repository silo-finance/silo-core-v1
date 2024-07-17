// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.7.6 <=0.9.0;

/// @title Types conversions
library TypesConversions {
    function toUint8(int256 input) internal pure returns (uint8 output) {
        // solhint-disable-next-line no-inline-assembly
        assembly { output := input }
    }

    function toUint256(int128 input) internal pure returns (uint256 output) {
        // solhint-disable-next-line no-inline-assembly
        assembly { output := input }
    }

    function toInt128(uint8 input) internal pure returns (int128 output) {
        // solhint-disable-next-line no-inline-assembly
        assembly { output := input }
    }
}
