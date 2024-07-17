// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../interfaces/ICurvePoolLike128.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @dev Curve pool exchange
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
library UsdcUsdt3poolLib {
    using SafeERC20 for IERC20;

    int128 constant public USDC_INDEX = 1;
    int128 constant public USDT_INDEX = 2;

    uint256 constant public UNKNOWN_AMOUNT = 1;

    function usdcToUsdtVia3Pool(
        uint256 _amount,
        address _pool,
        IERC20 _usdc,
        IERC20 _usdt
    )
        internal
        returns (uint256 _received)
    {
        _usdc.approve(_pool, _amount);

        uint256 balanceBefore = _usdt.balanceOf(address(this));

        ICurvePoolLike128(_pool).exchange(
            USDC_INDEX,
            USDT_INDEX,
            _amount,
            UNKNOWN_AMOUNT
        );

        uint256 balanceAfter = _usdt.balanceOf(address(this));

        // The `balanceAfter` can't be less than the `balanceBefore` after the exchange
        unchecked { _received = balanceAfter - balanceBefore; }
    }
}
