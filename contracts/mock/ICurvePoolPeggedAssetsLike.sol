// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

interface ICurvePoolPeggedAssetsLike {
  // solhint-disable func-name-mixedcase
  // solhint-disable func-param-name-mixedcase
  // solhint-disable var-name-mixedcase
  function exchange(int128 _i, int128 _j, uint256 _dx, uint256 _min_dy) external;
  function add_liquidity(uint256[2] memory _amounts, uint256 _min_mint_amount) external;
  function get_virtual_price() external view returns (uint256);
  function calc_withdraw_one_coin(uint256 _lpTokenAmount, int128 _coinIndex) external view returns (uint256);
  // solhint-enable func-name-mixedcase
  // solhint-enable func-param-name-mixedcase
  // solhint-enable var-name-mixedcase
}
