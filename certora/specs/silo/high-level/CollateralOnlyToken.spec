import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/Helpers.spec"

rule HLP_inverse_deposit_withdraw_collateralOnly(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(e.msg.sender);
    deposit(e, siloAssetToken, amount, collateralOnly);
    withdraw(e, siloAssetToken, amount, collateralOnly);
    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(e.msg.sender);

    assert diff_1(balanceAfter, balanceBefore),
        "Inverse deposit - withdraw for collateral only token failed";
}

rule HLP_inverse_deposit_withdrawFor_collateralOnly(env e1, env e2, uint256 amount, bool collateralOnly) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(e1.msg.sender);
    deposit(e1, siloAssetToken, amount, collateralOnly);
    withdrawFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, amount, collateralOnly);
    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(e1.msg.sender);

    assert diff_1(balanceAfter, balanceBefore),
        "Inverse deposit - withdrawFor for collateral only token failed";
}

rule HLP_inverse_depositFor_withdraw_collateralOnly(env e1, env e2, uint256 amount, bool collateralOnly) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(e2.msg.sender);
    depositFor(e1, siloAssetToken, e2.msg.sender, amount, collateralOnly);
    withdraw(e2, siloAssetToken, amount, collateralOnly);
    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(e2.msg.sender);

    assert diff_1(balanceAfter, balanceBefore),
        "Inverse deposit - withdrawFor for collateral only token failed";
}

rule HLP_inverse_depositFor_withdrawFor_collateralOnly(env e1, env e2, uint256 amount, bool collateralOnly) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(e2.msg.sender);
    depositFor(e1, siloAssetToken, e2.msg.sender, amount, collateralOnly);
    withdrawFor(e1, siloAssetToken, e2.msg.sender, e2.msg.sender, amount, collateralOnly);
    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(e2.msg.sender);

    assert diff_1(balanceAfter, balanceBefore),
        "Inverse depositFor - withdrawFor for collateral only token failed";
}

rule HLP_additive_deposit_collateralOnly(env e, uint256 x, uint256 y, bool collateralOnly) {
    basicConfig1Env(e);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    deposit(e, siloAssetToken, x + y, collateralOnly);
    uint256 balance1 = shareCollateralOnlyToken.balanceOf(e.msg.sender);

    deposit(e, siloAssetToken, x, collateralOnly) at initialStorage;
    deposit(e, siloAssetToken, y, collateralOnly);
    uint256 balance2 = shareCollateralOnlyToken.balanceOf(e.msg.sender);

    assert diff_1(balance1, balance2),
        "Deposit is not additive for collateral only token";
}

rule HLP_additive_depositFor_collateralOnly(env e1, env e2, uint256 x, uint256 y, bool collateralOnly) {
    basicConfig2Env(e1, e2);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    depositFor(e2, siloAssetToken, e1.msg.sender, x + y, collateralOnly);
    uint256 balance1 = shareCollateralOnlyToken.balanceOf(e1.msg.sender);

    depositFor(e2, siloAssetToken, e1.msg.sender, x, collateralOnly) at initialStorage;
    depositFor(e2, siloAssetToken, e1.msg.sender, y, collateralOnly);
    uint256 balance2 = shareCollateralOnlyToken.balanceOf(e1.msg.sender);

    assert diff_1(balance1, balance2),
        "DepositFor is not additive for collateral only token";
}

rule HLP_additive_withdraw_collateralOnly(env e, uint256 x, uint256 y, bool collateralOnly) {
    basicConfig1Env(e);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    require shareCollateralOnlyToken.balanceOf(e.msg.sender) >= x + y;

    withdraw(e, siloAssetToken, x + y, collateralOnly);
    uint256 balance1 = shareCollateralOnlyToken.balanceOf(e.msg.sender);

    withdraw(e, siloAssetToken, x, collateralOnly) at initialStorage;
    withdraw(e, siloAssetToken, y, collateralOnly);
    uint256 balance2 = shareCollateralOnlyToken.balanceOf(e.msg.sender);

    assert diff_1(balance1, balance2),
        "Withdraw is not additive for collateral only token";
}

rule HLP_additive_withdrawFor_collateralOnly(env e1, env e2, uint256 x, uint256 y, bool collateralOnly) {
    basicConfig2Env(e1, e2);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    require shareCollateralOnlyToken.balanceOf(e1.msg.sender) >= x + y;

    withdrawFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, x + y, collateralOnly);
    uint256 balance1 = shareCollateralOnlyToken.balanceOf(e1.msg.sender);

    withdrawFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, x, collateralOnly) at initialStorage;
    withdrawFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, y, collateralOnly);
    uint256 balance2 = shareCollateralOnlyToken.balanceOf(e1.msg.sender);

    assert diff_1(balance1, balance2),
        "WithdrawFor is not additive for collateral only token";
}

rule HLP_integrity_deposit_collateralOnly(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    uint256 depositedBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    deposit(e, siloAssetToken, amount, collateralOnly);
    uint256 depositedAfter = getAssetCollateralOnlyDeposits(siloAssetToken);

    assert collateralOnly => depositedBefore + amount == depositedAfter,
        "integrity of the total deposits is broken for collateral only token";
}

rule HLP_integrity_depositFor_collateralOnly(env e1, env e2, uint256 amount, bool collateralOnly) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 depositedBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    depositFor(e2, siloAssetToken, e1.msg.sender, amount, collateralOnly);
    uint256 depositedAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    
    assert collateralOnly => depositedBefore + amount == depositedAfter,
        "integrity of the total deposits is broken for collateral only token";
}

rule HLP_integrity_withdraw_collateralOnly(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    uint256 depositedBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    require depositedBefore < max_uint256;
    require amount <= depositedBefore;

    withdraw(e, siloAssetToken, amount, collateralOnly);
    uint256 depositedAfter = getAssetCollateralOnlyDeposits(siloAssetToken);

    assert collateralOnly => depositedBefore - amount == depositedAfter ||
        depositedAfter == 0 && depositedBefore - amount == 1 ||
        depositedAfter == 1 && depositedBefore == amount,
        "integrity of the total deposits is broken";
}

rule HLP_integrity_withdrawFor_collateralOnly(env e1, env e2, uint256 amount, bool collateralOnly) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 depositedBefore = getAssetCollateralOnlyDeposits(siloAssetToken);
    require depositedBefore < max_uint256;
    require amount <= depositedBefore;

    withdrawFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, amount, collateralOnly);
    uint256 depositedAfter = getAssetCollateralOnlyDeposits(siloAssetToken);
    
    assert collateralOnly => depositedBefore - amount == depositedAfter ||
        depositedAfter == 0 && depositedBefore - amount == 1 ||
        depositedAfter == 1 && depositedBefore == amount,
        "integrity of the total deposits is broken";
}

rule HLP_deposit_collateralOnly_update_only_sender(env e, uint256 amount, address someUser, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    require e.msg.sender != someUser;

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(someUser);

    deposit(e, siloAssetToken, amount, collateralOnly);

    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(someUser);

    assert collateralOnly => balanceBefore == balanceAfter,
        "CollateralOnly deposit update balance another account than msg.sender";
}

rule HLP_depositFor_collateralOnly_update_only_depositor(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    address depositor; address someUser;
    require depositor != someUser;

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(someUser);

    depositFor(e, siloAssetToken, depositor, amount, collateralOnly);

    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(someUser);

    assert collateralOnly => balanceBefore == balanceAfter,
        "CollateralOnly deposit update balance another account than depositor";
}

rule HLP_withdraw_collateralOnly_update_only_sender(env e, uint256 amount, address someUser, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    require e.msg.sender != someUser;

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(someUser);

    withdraw(e, siloAssetToken, amount, collateralOnly);

    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(someUser);

    assert collateralOnly => balanceBefore == balanceAfter,
        "CollateralOnly deposit update balance another account than depositor";
}

rule HLP_withdrawFor_collateralOnly_update_only_depositor(env e, uint256 amount, bool collateralOnly) {
    basicConfig1Env(e);
    requireAmount(amount);

    address depositor; address someUser;
    require depositor != someUser;

    uint256 balanceBefore = shareCollateralOnlyToken.balanceOf(someUser);

    withdrawFor(e, siloAssetToken, depositor, depositor, amount, collateralOnly);

    uint256 balanceAfter = shareCollateralOnlyToken.balanceOf(someUser);

    assert collateralOnly => balanceBefore == balanceAfter,
        "CollateralOnly deposit update balance another account than depositor";
}
