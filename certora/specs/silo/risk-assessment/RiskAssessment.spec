import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/Helpers.spec"

methods {
    getCompoundInterestRateAndUpdate(address, uint256) => DISPATCHER(true)
    isSiloPaused(address silo, address asset) returns bool => isNotPaused(silo, asset)
}

function isNotPaused(address silo, address asset) returns bool {
    return false;
}

function requireForTotal(uint256 totalSupply, uint256 totalDeposits, uint256 amount) {
    require totalSupply > 10^5 && totalDeposits > 10^5;
    require totalSupply >= amount;
    require totalDeposits >= amount;
    require totalDeposits >= totalSupply;
}

function requireTotals(uint256 amount) {
    uint256 collateralTotal = shareCollateralToken.totalSupply();
    uint256 totalDeposits = getAssetTotalDeposits(siloAssetToken);

    requireForTotal(collateralTotal, totalDeposits, amount);
    require liquidity(siloAssetToken) == totalDeposits;

    uint256 collateralOnlyTotal = shareCollateralOnlyToken.totalSupply();
    uint256 collateralOnlyDeposits = getAssetCollateralOnlyDeposits(siloAssetToken);

    requireForTotal(collateralOnlyTotal, collateralOnlyDeposits, amount);
}

rule RA_Silo_no_double_withdraw(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);

    withdraw(e, siloAssetToken, max_uint256, collateralOnly);
    withdraw@withrevert(e, siloAssetToken, max_uint256, collateralOnly);

    assert lastReverted, "Double spending on withdrawing";
}

rule RA_Silo_no_negative_interest_for_loan(env e1, env e2, uint256 amount, uint256 negativeInterest) {
    basicConfig1Env(e1);
    require negativeInterest > 1;
    require amount > negativeInterest + 1;

    uint256 beforeBorrow = shareDebtToken.balanceOf(e1.msg.sender);

    require e1.msg.sender == e2.msg.sender;
    require e1.block.timestamp < e2.block.timestamp;

    borrow(e1, siloAssetToken, amount);
    repay(e2, siloAssetToken, amount - negativeInterest);

    uint256 afterBorrow = shareDebtToken.balanceOf(e1.msg.sender);

    assert afterBorrow != 0, "User is able to repay a loan with less amount that borrowed";
}

rule RA_Silo_balance_more_than_collateralOnly_deposit(method f, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback}
{
    uint256 balanceBefore = siloAssetToken.balanceOf(currentContract);
    uint256 collateralOnlyDepositsBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    uint256 totalSupply = shareCollateralToken.totalSupply();

    require amount <= balanceBefore;
    require balanceBefore >= collateralOnlyDepositsBefore;

    requireForTotal(collateralOnlyDepositsBefore, totalSupply, amount);

    SFSWithInterestWithAmount(f, siloAssetToken, amount);

    uint256 balanceAfter = siloAssetToken.balanceOf(currentContract);
    uint256 collateralOnlyDepositsAfter = getAssetCollateralOnlyDeposits(siloAssetToken);

    // because of the rounding issue, assume that we can have an acceptable difference in 1 Wei
    mathint diff =  balanceAfter - collateralOnlyDepositsAfter;
    if (balanceAfter < collateralOnlyDepositsAfter) {
       diff = collateralOnlyDepositsAfter - balanceAfter;
    }

    assert balanceAfter >= collateralOnlyDepositsAfter || diff == 1, "Silo balance is less than the deposited amount";
}

rule RA_Silo_borrowed_asset_not_depositable(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    uint256 beforeBorrow = shareDebtToken.balanceOf(e.msg.sender);
    require beforeBorrow == 0;
    require assetIsActive(siloAssetToken) == true;

    borrow(e, siloAssetToken, amount);
    deposit@withrevert(e, siloAssetToken, amount, collateralOnly);

    assert lastReverted, "Deposited borrowed asset";
}

rule RA_Silo_withdraw_all_shares(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);

    require shareCollateralToken.balanceOf(e.msg.sender) == amount;
    require shareCollateralOnlyToken.balanceOf(e.msg.sender) == amount;

    withdraw(e, siloAssetToken, max_uint256, collateralOnly);

    assert collateralOnly => shareCollateralOnlyToken.balanceOf(e.msg.sender) == 0,
        "Failed to withdraw all";

    assert !collateralOnly => shareCollateralToken.balanceOf(e.msg.sender) == 0,
        "Failed to withdraw all";
}

rule RA_Silo_repay_all_shares(env e) {
    basicConfig1Env(e);

    require shareDebtToken.balanceOf(e.msg.sender) > 1;

    repay(e, siloAssetToken, max_uint256);
    uint256 balance = shareDebtToken.balanceOf(e.msg.sender);

    assert balance == 0, "Failed to repay all";
}

rule RA_Silo_repay_all_collateral(env e, uint256 amount) {
    basicConfig1Env(e);

    require shareDebtToken.balanceOf(e.msg.sender) == amount;
    require getAssetTotalBorrowAmount(siloAssetToken) == amount;
    require shareDebtToken.totalSupply() == amount;

    repay(e, siloAssetToken, max_uint256);

    uint256 balance = shareDebtToken.balanceOf(e.msg.sender);
    uint256 totalDeposits = getAssetTotalBorrowAmount(siloAssetToken);

    assert balance == 0 && totalDeposits == 0,
        "Failed to repay all";
}
