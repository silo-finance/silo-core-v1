// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import "../priceProviders/curveLPTokens/peggedAssetsPools/CurveReentrancyCheck.sol";

// solhint-disable func-name-mixedcase
// solhint-disable func-param-name-mixedcase
// solhint-disable var-name-mixedcase

// STETH pool interface with functions required for a test
interface ICurveSTETHPool {
    function add_liquidity(uint256[2] calldata _amounts, uint256 min_mint_amount) external payable returns (uint256);

    function remove_liquidity(
        uint256 _amount,
        uint256[2] calldata _amounts
    )
        external
        payable
        returns (uint256[2] memory);

    function remove_liquidity_one_coin(uint256 _tokenAmount, int128 i, uint256 _minAmount) external;
    function withdraw_admin_fees() external;
}

contract CurveReentrancyTest {
    CurveReentrancyCheck public provider;

    IERC20 public token = IERC20(0xae7ab96520DE3A18E5e111B5EaAb095312D7fE84); // stETH
    ICurveSTETHPool public pool = ICurveSTETHPool(0xDC24316b9AE028F1497c275EB9192a3Ea0f67022); // ETH/stETH pool

    error ExpectedToBeNotLockedButItIsLocked();

    event PoolIsLockedOnReceive(bool status);

    // Expect to be called while withdrawing liquidity from the stETH pool
    receive() external payable {
        bool poolIsLocked = provider.isLocked(address(pool));
        emit PoolIsLockedOnReceive(poolIsLocked);
    }

    fallback() external payable {
        revert("It should not execute in this test");
    }

    /// @notice Execute a reentrancy test
    function exec(address _provider, uint256 _amountToken) public payable {
        provider = CurveReentrancyCheck(_provider);

        // add liquidity
        token.approve(address(pool), _amountToken);

        uint[2] memory amounts = [msg.value, _amountToken];

        uint256 lps = pool.add_liquidity{value : msg.value}(amounts, 0);

        // remove liquidity

        // view function test
        bool poolIsLocked = CurveReentrancyCheck(_provider).isLocked(address(pool));

        if (poolIsLocked) revert ExpectedToBeNotLockedButItIsLocked();

        // execute function other than in the `isLocked` fn (`remove_liquidity`) but with the `lock`

        uint256 lpsRedeem = lps * 10 / 100; // 10 % redeem

        // expect a call on the ether transfer to the CurveReentrancyTest.receive() fn
        pool.remove_liquidity_one_coin(lpsRedeem, 0, 0); // expect the pool is locked
    }
}

// solhint-enable func-name-mixedcase
// solhint-enable func-param-name-mixedcase
// solhint-enable var-name-mixedcase
