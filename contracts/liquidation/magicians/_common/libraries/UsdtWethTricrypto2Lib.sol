// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "../../interfaces/ICurvePoolLike256.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/// @dev Curve pool exchange
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
library UsdtWethTricrypto2Lib {
    using SafeERC20 for IERC20;

    uint256 constant public USDT_INDEX = 0;
    uint256 constant public WETH_INDEX = 2;

    uint256 constant public UNKNOWN_AMOUNT = 1;

    function usdtToWethTricrypto2(
        uint256 _amount,
        address _pool,
        IERC20 _usdt,
        IERC20 _weth
    )
        internal
        returns (uint256 _received)
    {
        _usdt.safeApprove(_pool, _amount);

        uint256 balanceBefore = _weth.balanceOf(address(this));

        ICurvePoolLike256(_pool).exchange(
            USDT_INDEX,
            WETH_INDEX,
            _amount,
            UNKNOWN_AMOUNT
        );

        uint256 balanceAfter = _weth.balanceOf(address(this));

        // The `balanceAfter` can't be less than the `balanceBefore` after the exchange
        unchecked { _received = balanceAfter - balanceBefore; }
    }
}
