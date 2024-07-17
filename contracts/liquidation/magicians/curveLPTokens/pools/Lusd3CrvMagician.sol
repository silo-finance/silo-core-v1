// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../../_common/libraries/LusdUsdtAsUnderlying.sol";
import "../../_common/libraries/UsdtWethTricrypto2Lib.sol";
import "../../interfaces/IMagician.sol";

/// @dev Curve LP Tokens unwrapping
/// IT IS NOT PART OF THE PROTOCOL. SILO CREATED THIS TOOL, MOSTLY AS AN EXAMPLE.
contract Lusd3CrvMagician is IMagician {
    using LusdUsdtAsUnderlying for uint256;
    using UsdtWethTricrypto2Lib for uint256;

    /// @dev Index value for the coin (curve LUSD/3CRV pool)
    int128 public constant LUSD_INDEX_LUSD3CRV_POOL = 0;
    /// @dev Index value for the coin (curve LUSD/3CRV pool)
    int128 public constant CRV3LP_INDEX_LUSD3CRV_POOL = 1;

    uint256 constant public UNKNOWN_AMOUNT = 1;

    // solhint-disable var-name-mixedcase
    ICurvePoolLike128WithReturn public immutable LUSD_3CRV_POOL;
    address public immutable CRV3_POOL;
    address public immutable TRICTYPTO_2_POOL;

    IERC20 public immutable CRV_3_LP;
    IERC20 public immutable LUSD;
    IERC20 public immutable USDT;
    IERC20 public immutable WETH;
    // solhint-enable var-name-mixedcase

    /// @dev Revert on a `towardsAsset` call as it in unsupported 
    error Unsupported();
    /// @dev Revert in the constructor if provided an empty address
    error EmptyAddress();

    // solhint-disable-next-line code-complexity
    constructor(
        address _lusd3CrvPool,
        address _crv3Pool,
        address _tricrypto2,
        address _lusd,
        address _usdt,
        address _weth,
        address _crv3Lp
    ) {
        if (_lusd3CrvPool == address(0)) revert EmptyAddress();
        if (_crv3Pool == address(0)) revert EmptyAddress();
        if (_tricrypto2 == address(0)) revert EmptyAddress();
        if (_lusd == address(0)) revert EmptyAddress();
        if (_usdt == address(0)) revert EmptyAddress();
        if (_weth == address(0)) revert EmptyAddress();
        if (_crv3Lp == address(0)) revert EmptyAddress();

        LUSD_3CRV_POOL = ICurvePoolLike128WithReturn(_lusd3CrvPool);
        CRV3_POOL = _crv3Pool;
        TRICTYPTO_2_POOL = _tricrypto2;

        LUSD = IERC20(_lusd);
        USDT = IERC20(_usdt);
        WETH = IERC20(_weth);
        CRV_3_LP = IERC20(_crv3Lp);
    }

    /// @dev As Curve LP Tokens can be collateral-only assets we skip the implementation of this function
    function towardsAsset(address, uint256) external virtual pure returns (address, uint256) {
        revert Unsupported();
    }

    /// @inheritdoc IMagician
    function towardsNative(
        address,
        uint256 _amount
    )
        external
        virtual
        returns (address tokenOut, uint256 amountOut)
    {
        tokenOut = address(WETH);

        amountOut = LUSD_3CRV_POOL
            .remove_liquidity_one_coin(
                _amount,
                LUSD_INDEX_LUSD3CRV_POOL,
                UNKNOWN_AMOUNT
            )
            .lusdToUsdtViaCurve(address(LUSD_3CRV_POOL), LUSD)
            .usdtToWethTricrypto2(TRICTYPTO_2_POOL, USDT, WETH);
    }
}
