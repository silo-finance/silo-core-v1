// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../lib/RevertBytes.sol";
import "../interfaces/ISwapper.sol";

/// @dev it imitates how `LiquidationHelper` uses Swapper
contract UniswapV3SwapTester {
    using RevertBytes for bytes;

    bytes4 constant private _SWAP_AMOUNT_IN_SELECTOR =
        bytes4(keccak256("swapAmountIn(address,address,uint256,address,address)"));

    bytes4 constant private _SWAP_AMOUNT_OUT_SELECTOR =
        bytes4(keccak256("swapAmountOut(address,address,uint256,address,address)"));

    IERC20 public immutable quoteToken;

    constructor (IERC20 _quoteToken) {
        quoteToken = _quoteToken;
    }

    /// @param _tokenIn for UniswapV3SwapV2 can be address(0) because it is not in use
    /// @param _tokenOut for UniswapV3SwapV2 can be address(0) because it is not in use
    function swapForQuote(
        address _tokenIn,
        address _tokenOut,
        address _asset,
        uint256 _amount,
        ISwapper _swapper,
        address _priceProvider
    )
        external
        returns (uint256)
    {
        if (_amount == 0 || _asset == address(quoteToken)) revert ("invalid test case");

        bytes memory callData = abi.encodeWithSelector(
            _SWAP_AMOUNT_IN_SELECTOR,
            _tokenIn,
            _tokenOut,
            _amount,
            _priceProvider,
            _asset
        );

        // no need for safe approval, because we always using 100%
        IERC20(_asset).approve(_swapper.spenderToApprove(), _amount);
        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory data) = address(_swapper).delegatecall(callData);
        if (!success) data.revertBytes("swapForQuoteFailed");

        return abi.decode(data, (uint256));
    }

    /// @param _tokenIn for UniswapV3SwapV2 can be address(0) because it is not in use
    /// @param _tokenOut for UniswapV3SwapV2 can be address(0) because it is not in use
    function swapForAsset(
        address _tokenIn,
        address _tokenOut,
        address _asset,
        uint256 _amountOut,
        ISwapper _swapper,
        address _priceProvider
    )
        external
        returns (uint256)
    {
        if (_amountOut == 0 || address(quoteToken) == _asset) revert ("invalid test case");

        bytes memory callData = abi.encodeWithSelector(
            _SWAP_AMOUNT_OUT_SELECTOR,
            _tokenIn,
            _tokenOut,
            _amountOut,
            _priceProvider,
            _asset
        );

        address spender = _swapper.spenderToApprove();
        IERC20(quoteToken).approve(spender, type(uint256).max);

        // solhint-disable-next-line avoid-low-level-calls
        (bool success, bytes memory data) = address(_swapper).delegatecall(callData);
        if (!success) data.revertBytes("swapForAssetFailed");

        return abi.decode(data, (uint256));
    }
}
