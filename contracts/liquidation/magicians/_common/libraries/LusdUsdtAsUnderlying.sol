// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/ICurvePoolLike128WithReturn.sol";

/// @dev Curve pool exchange
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
library LusdUsdtAsUnderlying {
    /// @dev Index value for the coin (curve LUSD/3CRV pool)
    int128 public constant LUSD_INDEX_LUSD3CRV_POOL = 0;
    /// @dev Index value for the USDT as an underlying asset (curve LUSD/3CRV pool)
    int128 constant public USDT_INDEX = 3;

    uint256 constant public UNKNOWN_AMOUNT = 1;

    function lusdToUsdtViaCurve(uint256 _amount, address _pool, IERC20 _lusd) internal returns (uint256) {
        _lusd.approve(_pool, _amount);

        return ICurvePoolLike128WithReturn(_pool).exchange_underlying(
            LUSD_INDEX_LUSD3CRV_POOL,
            USDT_INDEX,
            _amount,
            UNKNOWN_AMOUNT
        );
    }
}
