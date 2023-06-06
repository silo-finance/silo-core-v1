import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/Helpers.spec"

methods {
    entryFee() returns uint256 => withoutEntryFee()
}

function withoutEntryFee() returns uint256 {
    return 0;
}

rule HLP_additive_borrow_debtToken(env e, uint256 x, uint256 y) {
    basicConfig1Env(e);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    borrow(e, siloAssetToken, x + y);
    uint256 balance1 = shareDebtToken.balanceOf(e.msg.sender);

    borrow(e, siloAssetToken, x) at initialStorage;
    borrow(e, siloAssetToken, y);
    uint256 balance2 = shareDebtToken.balanceOf(e.msg.sender);

    assert diff_1(balance1, balance2), "Borrow is not additive";
}

rule HLP_additive_borrowFor_debtToken(env e1, env e2, uint256 x, uint256 y, bool collateralOnly) {
    basicConfig2Env(e1, e2);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    borrowFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, x + y);
    uint256 balance1 = shareDebtToken.balanceOf(e1.msg.sender);

    borrowFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, x) at initialStorage;
    borrowFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, y);
    uint256 balance2 = shareDebtToken.balanceOf(e1.msg.sender);

    assert diff_1(balance1, balance2), "BorrowFor is not additive";
}

rule HLP_additive_repay_debtToken(env e, uint256 x, uint256 y) {
    basicConfig1Env(e);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    require shareDebtToken.balanceOf(e.msg.sender) >= x + y;

    repay(e, siloAssetToken, x + y);
    uint256 balance1 = shareDebtToken.balanceOf(e.msg.sender);

    repay(e, siloAssetToken, x) at initialStorage;
    repay(e, siloAssetToken, y);
    uint256 balance2 = shareDebtToken.balanceOf(e.msg.sender);

    assert diff_1(balance1, balance2), "Repay is not additive";
}

rule HLP_additive_repayFor_debtToken(env e1, env e2, uint256 x, uint256 y) {
    basicConfig2Env(e1, e2);

    require x > 1 && y > 1;

    storage initialStorage = lastStorage;

    require shareDebtToken.balanceOf(e1.msg.sender) >= x + y;

    repayFor(e2, siloAssetToken, e1.msg.sender, x + y);
    uint256 balance1 = shareDebtToken.balanceOf(e1.msg.sender);

    repayFor(e2, siloAssetToken, e1.msg.sender, x) at initialStorage;
    repayFor(e2, siloAssetToken, e1.msg.sender, y);
    uint256 balance2 = shareDebtToken.balanceOf(e1.msg.sender);

    assert diff_1(balance1, balance2), "repayFor is not additive";
}

rule HLP_integrity_borrow_debtToken(env e, uint256 amount) {
    basicConfig1Env(e);
    requireAmount(amount);

    uint256 borrowedBefore = getAssetTotalBorrowAmount(siloAssetToken);
    borrow(e, siloAssetToken, amount);
    uint256 borrowedAfter = getAssetTotalBorrowAmount(siloAssetToken);

    assert borrowedBefore + amount == borrowedAfter,
        "integrity of the total borrow is broken";
}

rule HLP_integrity_borrowFor_debtToken(env e1, env e2, uint256 amount) {
    basicConfig2Env(e1, e2);
    requireAmount(amount);

    uint256 borrowedBefore = getAssetTotalBorrowAmount(siloAssetToken);
    borrowFor(e2, siloAssetToken, e1.msg.sender, e1.msg.sender, amount);
    uint256 borrowedAfter = getAssetTotalBorrowAmount(siloAssetToken);

    assert borrowedBefore + amount == borrowedAfter,
        "integrity of the total borrow is broken";
}

rule HLP_borrow_update_only_sender(env e, uint256 amount, address someUser) {
    basicConfig1Env(e);
    requireAmount(amount);

    require e.msg.sender != someUser;

    uint256 borrowedBefore = shareDebtToken.balanceOf(someUser);
    borrow(e, siloAssetToken, amount);
    uint256 borrowedAfter = shareDebtToken.balanceOf(someUser);

    assert borrowedBefore == borrowedAfter,
        "borrow update balance another account than msg.sender";
}

rule HLP_borrowFor_update_only_borrower(env e, uint256 amount, address borrower, address someUser) {
    basicConfig1Env(e);
    requireAmount(amount);

    require borrower != someUser;

    uint256 borrowedBefore = shareDebtToken.balanceOf(someUser);
    borrowFor(e, siloAssetToken, borrower, borrower, amount);
    uint256 borrowedAfter = shareDebtToken.balanceOf(someUser);

    assert borrowedBefore == borrowedAfter,
        "borrowFor update balance another account than borrower";
}

rule HLP_repay_update_only_sender(env e, uint256 amount, address someUser) {
    basicConfig1Env(e);
    requireAmount(amount);

    require e.msg.sender != someUser;

    uint256 borrowedBefore = shareDebtToken.balanceOf(someUser);
    repay(e, siloAssetToken, amount);
    uint256 borrowedAfter = shareDebtToken.balanceOf(someUser);

    assert borrowedBefore == borrowedAfter,
        "repay update balance another account than msg.sender";
}

rule HLP_repayFor_update_only_borrower(env e, uint256 amount, address borrower, address someUser) {
    basicConfig1Env(e);
    requireAmount(amount);

    require borrower != someUser;

    uint256 borrowedBefore = shareDebtToken.balanceOf(someUser);
    repayFor(e, siloAssetToken, borrower, amount);
    uint256 borrowedAfter = shareDebtToken.balanceOf(someUser);

    assert borrowedBefore == borrowedAfter,
        "repayFor update balance another account than borrower";
}
