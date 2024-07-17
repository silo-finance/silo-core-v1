// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../interfaces/IMagician.sol";
import "./PendleMagician.sol";
import "./interfaces/balancer/IVaultLike.sol";
import "./interfaces/balancer/IAsset.sol";

contract PendlePTEzETH26DEC2024MagicianEth is PendleMagician, IMagician {
    // solhint-disable
    address public constant EZETH = 0xbf5495Efe5DB9ce00f80364C8B423567e58d2110;
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;
    bytes32 public constant POOL_ID = 0x596192bb6e41802428ac943d2f1476c1af25cc0e000000000000000000000659;
    // solhint-enable

    constructor() PendleMagician(
        0xf7906F274c174A52d444175729E3fa98f9bde285, // PT Token
        0xD8F12bCDE578c653014F27379a6114F67F0e445f  // PT Market
    ) {}

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
