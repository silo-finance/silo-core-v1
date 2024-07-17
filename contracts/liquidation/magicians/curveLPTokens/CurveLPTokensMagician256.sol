// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./CurveLPTokensMagician.sol";
import "../interfaces/ICurvePoolExchange256.sol";
import "../interfaces/ICurveLPTokensPriceProviderLike.sol";
import "../../../interfaces/IPriceProvidersRepository.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
contract CurveLPTokensMagician256 is CurveLPTokensMagician {
    constructor(
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        IPriceProvidersRepository _priceProvidersRepository
    )
        CurveLPTokensMagician(
            _fetchersRepository,
            _priceProvidersRepository
        )
    {
        // initial setup is done in CurveLPTokensMagician, nothing to do here
    }

    function towardsNative(
        address _asset,
        uint256 _amount
    )
        external
        virtual
        returns (address tokenOut, uint256 amountOut)
    {
        address poolAddress;
        (poolAddress, tokenOut) = _getPoolAndCoin(_asset);

        ICurvePoolExchange256 pool = ICurvePoolExchange256(poolAddress);

        uint256 i = uint256(poolCoins[_asset].index);
        uint256 amountToWithdraw = pool.calc_withdraw_one_coin(_amount, i);

        uint256 swapperBalBefore = IERC20LikeV2(tokenOut).balanceOf(address(this));

        // some versions of the Curve pools like 3Crv (0xbEbc44782C7dB0a1A60Cb6fe97d0b483032FF1C7)
        // do not have a return value in the `remove_liquidity_one_coin` function
        // because of this we are calculating `amountOut`
        pool.remove_liquidity_one_coin(_amount, i, amountToWithdraw);

        uint256 swapperBalAfter = IERC20LikeV2(tokenOut).balanceOf(address(this));

        // Balance after withdrawal can't be less than it was before
        unchecked { amountOut = swapperBalAfter - swapperBalBefore; }
    }
}
