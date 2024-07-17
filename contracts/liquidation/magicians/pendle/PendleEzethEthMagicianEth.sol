// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IMagician.sol";
import "./PendleMagician.sol";
import "./interfaces/balancer/IVaultLike.sol";
import "./interfaces/balancer/IAsset.sol";

contract PendleEzethEthMagicianEth is PendleMagician, IMagician {
    // solhint-disable
    address public immutable EZETH;
    address public immutable WETH;
    address public immutable VAULT;
    bytes32 public immutable POOL_ID;
    // solhint-enable

    constructor(
        address _asset,
        address _market,
        address _weth,
        address _ezeth,
        address _vault,
        bytes32 _poolId
    ) PendleMagician(_asset, _market) {
        WETH = _weth;
        EZETH = _ezeth;
        VAULT = _vault;
        POOL_ID = _poolId;
    }

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        asset = WETH;
        uint256 amountEzeth = _sellPtForUnderlying(_amount, EZETH);

        IERC20(EZETH).approve(VAULT, amountEzeth);

        amount = _swapEzETH(amountEzeth);
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _swapEzETH(uint256 _amountIn) internal returns (uint256 amountWeth) {
        IVaultLike.SingleSwap memory singleSwap = IVaultLike.SingleSwap(
            POOL_ID, IVaultLike.SwapKind.GIVEN_IN, IAsset(EZETH), IAsset(WETH), _amountIn, ""
        );

        IVaultLike.FundManagement memory funds = IVaultLike.FundManagement(
            address(this), false, payable(address(this)), false
        );

        uint256 limit = 1;
        amountWeth = IVaultLike(VAULT).swap(singleSwap, funds, limit, block.timestamp);
    }
}
