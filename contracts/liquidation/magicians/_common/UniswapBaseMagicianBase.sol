// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/swap-router-contracts/contracts/interfaces/IV3SwapRouter.sol";
import "../interfaces/IMagician.sol";

abstract contract UniswapBaseMagicianBase is IMagician {
    // solhint-disable
    IV3SwapRouter public constant ROUTER = IV3SwapRouter(0x2626664c2603336E57B271c5C0b26F421741e481);
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

        IV3SwapRouter.ExactInputSingleParams memory params = IV3SwapRouter.ExactInputSingleParams({
            tokenIn: _asset,
            tokenOut: WETH,
            fee: POOL_FEE,
            recipient: address(this),
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

        IV3SwapRouter.ExactOutputSingleParams memory params = IV3SwapRouter.ExactOutputSingleParams({
            tokenIn: WETH,
            tokenOut: _asset,
            fee: POOL_FEE,
            recipient: address(this),
            amountOut: _amount,
            amountInMaximum: type(uint256).max,
            sqrtPriceLimitX96: 0
        });

        asset = _asset;
        amount = ROUTER.exactOutputSingle(params);
        IERC20(WETH).approve(address(ROUTER), 0);
    }
}
