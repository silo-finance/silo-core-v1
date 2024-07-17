// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IMagician.sol";
import "./PendleMagician.sol";
import "./interfaces/camelot/ICamelotSwapRouterLike.sol";

abstract contract PendleCamelotMagicianV2 is PendleMagician, IMagician {
    // solhint-disable
    ICamelotSwapRouterLike public constant ROUTER = ICamelotSwapRouterLike(0x1F721E2E82F6676FCE4eA07A5958cF098D339e18);
    address public constant WETH = 0x82aF49447D8a07e3bd95BD0d56f35241523fBab1;
    address public immutable UNDERLYING;
    // solhint-enable

    constructor(
        address _asset,
        address _market,
        address _underlying
    ) PendleMagician(_asset, _market) {
        UNDERLYING = _underlying;
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        uint256 amountUnderlying = _sellPtForUnderlying(_amount, UNDERLYING);

        IERC20(UNDERLYING).approve(address(ROUTER), amountUnderlying);

        asset = WETH;
        amount = _camelotSwap(amountUnderlying);
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _camelotSwap(uint256 _amountIn) internal returns (uint256 amountWeth) {
        ICamelotSwapRouterLike.ExactInputSingleParams memory params = ICamelotSwapRouterLike.ExactInputSingleParams({
            tokenIn: UNDERLYING,
            tokenOut: WETH,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 1,
            limitSqrtPrice: 0
        });

        return ROUTER.exactInputSingle(params);
    }
}
