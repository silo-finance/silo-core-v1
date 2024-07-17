// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

library NormalizeWithDecimalsLib {
    error DivisionResultIsZero();

    /// @dev Adjusts the given value to have different decimals
    function normalizeWithDecimals(
        uint256 _value,
        uint256 _toDecimals,
        uint256 _fromDecimals
    )
        internal
        pure
        returns (uint256)
    {
        if (_toDecimals == _fromDecimals) {
            return _value;
        }

        if (_toDecimals < _fromDecimals) {
            uint256 divideOn;
            // It can be unchecked because of the condition `_toDecimals < _fromDecimals`.
            // We trust to `_fromDecimals` and `_toDecimals` they should not have large numbers.
            unchecked { divideOn = 10 ** (_fromDecimals - _toDecimals); }
            // Zero value after normalization is unacceptable.
            if (_value < divideOn) revert DivisionResultIsZero();
            // Assertion above make it safe
            unchecked { return _value / divideOn; }
        }

        uint256 decimalsDiff;
        // Because of the condition `_toDecimals < _fromDecimals` above,
        // we are safe as it guarantees that `_toDecimals` is > `_fromDecimals`
        unchecked { decimalsDiff = 10 ** (_toDecimals - _fromDecimals); }

        return _value * decimalsDiff;
    }
}
