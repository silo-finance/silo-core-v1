// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./CurveLPTokensMagicianETH.sol";
import "../../interfaces/ICurvePoolExchange256.sol";
import "../../interfaces/IWETH9Like.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
contract CurveLPTokensMagicianETH256 is CurveLPTokensMagicianETH {
    constructor(
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        IPriceProvidersRepository _priceProvidersRepository,
        address _weth,
        address _nullAddress
    )
        CurveLPTokensMagicianETH(
            _fetchersRepository,
            _priceProvidersRepository,
            _weth,
            _nullAddress
        )
    {
        // initial setup is done in CurveLPTokensMagicianETH and CurveLPTokensMagician, nothing to do here
    }

    function towardsNative(
        address _asset,
        uint256 _amount
    )
        external
        override
        returns (address tokenOut, uint256 amountOut)
    {
        address poolAddress;
        (poolAddress, tokenOut) = _getPoolAndCoin(_asset);

        IERC20LikeV2 token = tokenOut == NULL_ADDRESS ? IERC20LikeV2(WETH) : IERC20LikeV2(tokenOut);

        ICurvePoolExchange256 pool = ICurvePoolExchange256(poolAddress);

        uint256 i = uint256(poolCoins[_asset].index);
        uint256 amountToWithdraw = pool.calc_withdraw_one_coin(_amount, i);

        uint256 swapperBalBefore = token.balanceOf(address(this));

        // some versions of the Curve pools like 3Crv (0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7)
        // do not have a return value in the `remove_liquidity_one_coin` function
        // because of this we are calculating `amountOut`
        pool.remove_liquidity_one_coin(_amount, i, amountToWithdraw);

        tokenOut = _reviewTokenOut(tokenOut, amountToWithdraw);

        uint256 swapperBalAfter = token.balanceOf(address(this));

        // Balance after withdrawal can't be less than it was before
        unchecked { amountOut = swapperBalAfter - swapperBalBefore; }
    }
}
