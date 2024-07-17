// SPDX-License-Identifier: BUSL-1.1
pragma solidity >=0.7.6 <=0.9.0;

/// @title Math helper functions
library MathHelpers {
    /// @notice It will not support an array with `0` or `1` element.
    /// @dev Returns a minimal value from the provided array.
    /// @param _values A list of values from which will be selected a lower value
    /// @return min A lower value from the `_values` array
    function minValue(uint256[] memory _values) internal pure returns (uint256 min) {
        min = _values[0] > _values[1] ? _values[1] : _values[0];
        uint256 i = 2;

        while(i < _values.length) {
            if (min > _values[i]) {
                min = _values[i];
            }

            // Variable 'i' and '_values.length' have the same data type,
            // so due to condition (i < _values.length) overflow is impossible.
            unchecked { i++; }
        }
    }
}
