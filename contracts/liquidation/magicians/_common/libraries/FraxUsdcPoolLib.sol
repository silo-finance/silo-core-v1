// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../interfaces/ICurvePoolLike128WithReturn.sol";

/// @dev Curve pool exchange
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
library FraxUsdcPoolLib {
    int128 constant public FRAX_INDEX = 0;
    int128 constant public USDC_INDEX = 1;

    uint256 constant public UNKNOWN_AMOUNT = 1;

    function fraxToUsdcViaCurve(uint256 _amount, address _pool, IERC20 _frax) internal returns (uint256) {
        _frax.approve(_pool, _amount);

        return ICurvePoolLike128WithReturn(_pool).exchange(
            FRAX_INDEX,
            USDC_INDEX,
            _amount,
            UNKNOWN_AMOUNT
        );
    }

    function usdcToFraxViaCurve(uint256 _amount, address _pool, IERC20 _usdc) internal returns (uint256) {
        _usdc.approve(_pool, _amount);

        return ICurvePoolLike128WithReturn(_pool).exchange(
            USDC_INDEX,
            FRAX_INDEX,
            _amount,
            UNKNOWN_AMOUNT
        );
    }
}
