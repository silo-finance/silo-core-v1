// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/IMagician.sol";
import "./PendleMagician.sol";

abstract contract PendleUniswapMagician is PendleMagician, IMagician {
    // solhint-disable var-name-mixedcase
    ISwapRouter public immutable UNISWAP_ROUTER;
    uint24 public immutable FEE;
    // solhint-enable var-name-mixedcase

    constructor(
        address _router,
        uint24 _fee,
        address _ptToken,
        address _ptMarket
    ) PendleMagician(_ptToken, _ptMarket) {
        UNISWAP_ROUTER = ISwapRouter(_router);
        FEE = _fee;
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        asset = _toToken();
        uint256 amountWeeth = _sellPtForUnderlying(_amount, _fromToken());

        IERC20(_fromToken()).approve(address(UNISWAP_ROUTER), amountWeeth);

        amount = _swapWeeth(amountWeeth);
    }

    /// @inheritdoc IMagician
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _swapWeeth(uint256 _amountIn) internal returns (uint256 amountOut) {
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: _fromToken(),
            tokenOut: _toToken(),
            fee: FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        return UNISWAP_ROUTER.exactInputSingle(params);
    }

    function _fromToken() internal pure virtual returns (address) {}
    
    function _toToken() internal pure virtual returns (address) {}
}
