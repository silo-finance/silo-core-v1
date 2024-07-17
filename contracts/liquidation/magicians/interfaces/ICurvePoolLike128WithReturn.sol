// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

interface ICurvePoolLike128WithReturn {
    // solhint-disable func-name-mixedcase
    function exchange(int128 i, int128 j, uint256 dx, uint256 minDy) external returns (uint256);
    function remove_liquidity_one_coin(uint256 amount, int128 i, uint256 minDy) external returns (uint256);
    function exchange_underlying(int128 _i, int128 _j, uint256 _dx, uint256 _minDy) external returns (uint256);
    function get_dy(int128 i, int128 j, uint256 dx) external view returns (uint256);
    // solhint-enable func-name-mixedcase
}
