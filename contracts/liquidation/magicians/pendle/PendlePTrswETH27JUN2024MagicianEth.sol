// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "./PendleMagician.sol";
import "../interfaces/IMagician.sol";
import "./interfaces/balancer/IVaultLike.sol";
import "./interfaces/balancer/IAsset.sol";

contract PendlePTrswETH27JUN2024MagicianEth is PendleMagician, IMagician {
    address public constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address public constant RSWETH = 0xFAe103DC9cf190eD75350761e95403b7b8aFa6c0;
    address public constant EZETH = 0xbf5495Efe5DB9ce00f80364C8B423567e58d2110;
    address public constant BALANCER_VAULT = 0xBA12222222228d8Ba445958a75a0704d566BF2C8;

    bytes32 public constant RSW_BALANCE_POOL_ID = 0x848a5564158d84b8a8fb68ab5d004fae11619a5400000000000000000000066a;
    bytes32 public constant EZETH_BALANCE_POOL_ID = 0x596192bb6e41802428ac943d2f1476c1af25cc0e000000000000000000000659;
    
    constructor() PendleMagician(
        0x5cb12D56F5346a016DBBA8CA90635d82e6D1bcEa, // PT Token
        0xA9355a5d306c67027C54De0e5a72df76Befa5694  // PT Market
    ) {}

    /// @inheritdoc IMagician
    function towardsNative(address _asset, uint256 _amount) external returns (address asset, uint256 amount) {
        if (_asset != address(PENDLE_TOKEN)) revert InvalidAsset();

        uint256 amountRswETH = _sellPtForUnderlying(_amount, RSWETH);

        IERC20(RSWETH).approve(BALANCER_VAULT, amountRswETH);
        uint256 ezEthAmount = _swapViaBalancer(amountRswETH, RSW_BALANCE_POOL_ID, RSWETH, EZETH);

        IERC20(EZETH).approve(BALANCER_VAULT, ezEthAmount);
        amount = _swapViaBalancer(ezEthAmount, EZETH_BALANCE_POOL_ID, EZETH, WETH);

        asset = WETH;
    }

    /// @inheritdoc IMagician
    // solhint-disable-next-line named-return-values
    function towardsAsset(address, uint256) external pure returns (address, uint256) {
        revert Unsupported();
    }

    function _swapViaBalancer(
        uint256 _amountIn,
        bytes32 _poolId,
        address _from,
        address _to
    ) internal returns (uint256 receivedAmount) {
        IVaultLike.SingleSwap memory singleSwap = IVaultLike.SingleSwap(
            _poolId, IVaultLike.SwapKind.GIVEN_IN, IAsset(_from), IAsset(_to), _amountIn, ""
        );

        IVaultLike.FundManagement memory funds = IVaultLike.FundManagement(
            address(this), false, payable(address(this)), false
        );

        uint256 limit = 1;
        receivedAmount = IVaultLike(BALANCER_VAULT).swap(singleSwap, funds, limit, block.timestamp);
    }
}
