// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../CurveLPTokensMagician128.sol";
import "../../_common/libraries/FraxUsdcPoolLib.sol";
import "../../_common/libraries/UsdcUsdt3poolLib.sol";
import "../../_common/libraries/UsdtWethTricrypto2Lib.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
contract FraxCurveMagician is CurveLPTokensMagician128 {
    using FraxUsdcPoolLib for uint256;
    using UsdcUsdt3poolLib for uint256;
    using UsdtWethTricrypto2Lib for uint256;

    // solhint-disable var-name-mixedcase
    address public immutable CRV_3_POOL;
    address public immutable TRICTYPTO_2_POOL;

    IERC20 public immutable USDC;
    IERC20 public immutable USDT;
    IERC20 public immutable WETH;
    IERC20 public immutable FRAX;
    // solhint-enable var-name-mixedcase

    error EmptyAddress();

    constructor(
        ICurveLPTokensDetailsFetchersRepository _fetchersRepository,
        IPriceProvidersRepository _priceProvidersRepository,
        address _crv3Pool,
        address _tricrypto2,
        address _usdc,
        address _usdt,
        address _weth,
        address _frax
    )
        CurveLPTokensMagician128(
            _fetchersRepository,
            _priceProvidersRepository
        )
    {
        if (_crv3Pool == address(0)) revert EmptyAddress();
        if (_tricrypto2 == address(0)) revert EmptyAddress();
        if (_usdc == address(0)) revert EmptyAddress();
        if (_usdt == address(0)) revert EmptyAddress();
        if (_weth == address(0)) revert EmptyAddress();
        if (_frax == address(0)) revert EmptyAddress();

        CRV_3_POOL = _crv3Pool;
        TRICTYPTO_2_POOL = _tricrypto2;

        USDC = IERC20(_usdc);
        USDT = IERC20(_usdt);
        WETH = IERC20(_weth);
        FRAX = IERC20(_frax);
    }

    function towardsNative(
        address _asset,
        uint256 _amount
    )
        external
        override
        returns (address tokenOut, uint256 amountOut)
    {
        (, uint256 fraxAmount, address poolAddress) = _towardsNative(_asset, _amount);

        tokenOut = address(WETH);

        amountOut = fraxAmount
            .fraxToUsdcViaCurve(poolAddress, FRAX)
            .usdcToUsdtVia3Pool(CRV_3_POOL, USDC, USDT)
            .usdtToWethTricrypto2(TRICTYPTO_2_POOL, USDT, WETH);
    }
}
