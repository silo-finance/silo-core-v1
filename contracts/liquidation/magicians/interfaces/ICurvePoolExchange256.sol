// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./ICurvePoolLike256.sol";

interface ICurvePoolExchange256 is ICurvePoolLike256 {
    // solhint-disable-next-line func-name-mixedcase
    function remove_liquidity_one_coin(uint256 _tokenAmount, uint256 i, uint256 _minAmount) external;
    // solhint-disable-next-line func-name-mixedcase
    function calc_withdraw_one_coin(uint256 _tokenAmount, uint256 i) external view returns (uint256);
}
