// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol";

import "../interfaces/IMagician.sol";
import "./interfaces/IStandardizedYield.sol";
import "./interfaces/IPPrincipalToken.sol";
import "./interfaces/IPYieldToken.sol";
import "./interfaces/IPMarket.sol";

interface IUniswapPoolLike {
    function fee() external view returns (uint24 feeAmount);
}

contract PendleWeethMagician is IMagician {
    // solhint-disable
    ISwapRouter public immutable uniswapRouter;
    address public immutable PENDLE_TOKEN;
    address public immutable PENDLE_MARKET;
    address public immutable WEETH;
    address public immutable WETH;
    uint24 public immutable FEE;
    // solhint-enable

    bytes internal constant _EMPTY_BYTES = abi.encode();

    error InvalidAsset();
    error Unsupported();

    constructor(
        address _asset,
        address _market,
        address _weth,
        address _weeth,
        address _uniswapPool,
        address _router
    ) {
        PENDLE_TOKEN = _asset;
        PENDLE_MARKET = _market;
        WETH = _weth;
        WEETH = _weeth;
        uniswapRouter = ISwapRouter(_router);
        IUniswapPoolLike pool = IUniswapPoolLike(_uniswapPool);
        FEE = pool.fee();
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        asset = WETH;
        uint256 amountWeeth = _sellPtForWeeth(_amount);

        IERC20(WEETH).approve(address(uniswapRouter), amountWeeth);

        amount = _swapWeeth(amountWeeth);
    }

    /// @inheritdoc IMagician
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _sellPtForWeeth(uint256 netPtIn) internal returns (uint256 netTokenOut) {
        // solhint-disable-next-line var-name-mixedcase
        (IStandardizedYield SY, IPPrincipalToken PT, IPYieldToken YT) = IPMarket(PENDLE_MARKET)
            .readTokens();

        uint256 netSyOut;
        if (PT.isExpired()) {
            PT.transfer(address(YT), netPtIn);
            netSyOut = YT.redeemPY(address(SY));
        } else {
            // safeTransfer not required
            PT.transfer(PENDLE_MARKET, netPtIn);
            (netSyOut, ) = IPMarket(PENDLE_MARKET).swapExactPtForSy(
                address(SY), // better gas optimization to transfer SY directly to itself and burn
                netPtIn,
                _EMPTY_BYTES
            );
        }

        netTokenOut = SY.redeem(address(this), netSyOut, WEETH, 0, true);
    }

    function _swapWeeth(uint256 _amountIn) internal returns (uint256 amountOut) {
        ISwapRouter.ExactInputSingleParams memory params = ISwapRouter.ExactInputSingleParams({
            tokenIn: WEETH,
            tokenOut: WETH,
            fee: FEE,
            recipient: address(this),
            deadline: block.timestamp,
            amountIn: _amountIn,
            amountOutMinimum: 1,
            sqrtPriceLimitX96: 0
        });

        return uniswapRouter.exactInputSingle(params);
    }
}
