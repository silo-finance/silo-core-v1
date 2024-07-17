// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IMagician.sol";
import "./PendleMagician.sol";
import "./interfaces/camelot/ICamelotSwapRouterLike.sol";

abstract contract PendleCamelotMagician is PendleMagician, IMagician {
    // solhint-disable
    address public immutable RSETH;
    address public immutable WETH;
    address public immutable POOL;
    ICamelotSwapRouterLike public immutable ROUTER;
    // solhint-enable

    constructor(
        address _asset,
        address _market,
        address _weth,
        address _ezeth,
        address _router,
        address _pool
    ) PendleMagician(_asset, _market) {
        WETH = _weth;
        RSETH = _ezeth;
        POOL = _pool;
        ROUTER = ICamelotSwapRouterLike(_router);
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        uint256 amountRsEth = _sellPtForUnderlying(_amount, RSETH);

        IERC20(RSETH).approve(address(ROUTER), amountRsEth);

        asset = WETH;
        amount = _swapRsETH(amountRsEth);
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _swapRsETH(uint256 _amountIn) internal returns (uint256 amountWeth) {
        ICamelotSwapRouterLike.ExactInputSingleParams memory params = ICamelotSwapRouterLike.ExactInputSingleParams({
            tokenIn: RSETH,
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
