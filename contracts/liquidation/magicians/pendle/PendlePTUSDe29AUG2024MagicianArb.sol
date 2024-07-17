// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "./PendleMagician.sol";
import "../interfaces/IMagician.sol";
import "./interfaces/camelot/ICamelotSwapRouterLike.sol";

contract PendlePTUSDe29AUG2024MagicianArb is PendleMagician, IMagician {
    // solhint-disable
    address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public constant USDC = 0xaf88d065e77c8cC2239327C5EDb3A432268e5831;
    address public constant UNDERLYING = 0x5d3a1Ff2b6BAb83b63cd9AD0787074081a52ef34;

    uint24 public constant UNISWAP_POOL_FEE = 500;
    ICamelotSwapRouterLike public constant CAMELOT_ROUTER = ICamelotSwapRouterLike(0x1F721E2E82F6676FCE4eA07A5958cF098D339e18);
    ISwapRouter public immutable UNISWAP_ROUTER = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    // solhint-enable

    constructor() PendleMagician(
        0xad853EB4fB3Fe4a66CdFCD7b75922a0494955292, // PT token
        0x2Dfaf9a5E4F293BceedE49f2dBa29aACDD88E0C4  // PT market
    ) {}

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        uint256 amountUnderlying = _sellPtForUnderlying(_amount, UNDERLYING);

        asset = WETH;
        amount = _swapUnderlyingOnDEXes(amountUnderlying);
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _swapUnderlyingOnDEXes(uint256 _amountIn) internal returns (uint256 amountWeth) {
        // UNDERLYING(USDe) -> USDC on Camelot
        IERC20(UNDERLYING).approve(address(CAMELOT_ROUTER), _amountIn);

        ICamelotSwapRouterLike.ExactInputSingleParams memory params = ICamelotSwapRouterLike.ExactInputSingleParams({
            tokenIn: UNDERLYING,
            tokenOut: USDC,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 1,
            limitSqrtPrice: 0
        });

        uint256 usdcOut = CAMELOT_ROUTER.exactInputSingle(params);

        // USDC -> WETH on Uniswap
        IERC20(USDC).approve(address(UNISWAP_ROUTER), usdcOut);

        ISwapRouter.ExactInputSingleParams memory uniswapParams = ISwapRouter.ExactInputSingleParams({
            tokenIn: USDC,
            tokenOut: WETH,
            fee: UNISWAP_POOL_FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: usdcOut,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        return UNISWAP_ROUTER.exactInputSingle(uniswapParams);
    }
}
