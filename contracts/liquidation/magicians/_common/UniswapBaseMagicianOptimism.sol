// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";
import "../interfaces/IMagician.sol";

abstract contract UniswapBaseMagicianOptimism is IMagician {
    // solhint-disable
    ISwapRouter public constant ROUTER = ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    address public constant WETH = 0x4200000000000000000000000000000000000006;
    address public immutable ASSET;
    uint24 public immutable POOL_FEE;
    // solhint-enable

    error InvalidAsset();

    constructor(address _asset, uint24 _fee) {
        ASSET = _asset;
        POOL_FEE = _fee;
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsNative(address _asset, uint256 _amount) external returns (address, uint256) {
        if (_asset != address(ASSET)) revert InvalidAsset();

        IERC20(_asset).approve(address(ROUTER), _amount);

        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: _asset,
            tokenOut: WETH,
            fee: POOL_FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amount,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        return (WETH, ROUTER.exactInputSingle(params));
    }

    /// @inheritdoc IMagician
    function towardsAsset(
        address _asset,
        uint256 _amount
    ) external returns (address asset, uint256 amount) {
        if (_asset != address(ASSET)) revert InvalidAsset();

        IERC20(WETH).approve(address(ROUTER), type(uint256).max);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter.ExactOutputSingleParams({
            tokenIn: WETH,
            tokenOut: _asset,
            fee: POOL_FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountOut: _amount,
            amountInMaximum: type(uint256).max,
            sqrtPriceLimitX96: 0
        });

        asset = _asset;
        amount = ROUTER.exactOutputSingle(params);
        IERC20(WETH).approve(address(ROUTER), 0);
    }
}
