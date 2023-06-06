methods {
    toShareWrapped(uint256 amount, uint256 totalDeposits, uint256 totalShares) returns (uint256) envfree    
    toAmountWrapped(uint256 shares, uint256 totalDeposits, uint256 totalShares) returns (uint256) envfree
}

definition minTotals() returns uint256 = to_uint256(10^5);

// assuming that minTotals() is minimal value for total deposits and total shares
// because of the limitation for the first mint that has been introduced for the shares token
function require_totals(uint256 totalShares, uint256 totalDeposits) {
    require totalShares > minTotals() && totalDeposits > minTotals();
    require totalShares <= totalDeposits;
}

function require_totals_amount(uint256 totalShares, uint256 totalDeposits, uint256 amount) {
    require_totals(totalShares, totalDeposits);
    require amount > 0;
}

function require_totals_x_y(uint256 totalShares, uint256 totalDeposits, uint256 x, uint256 y) {
    require_totals(totalShares, totalDeposits);
    require x > 0 && y > 0;
}

rule MP_monotonicity_amount_toShares(uint256 x, uint256 y) {
    uint256 totalDeposits;
    uint256 totalShares;

    require_totals_x_y(totalShares, totalDeposits, x, y);

    uint256 toSharesX = toShareWrapped(x, totalDeposits, totalShares);
    uint256 toSharesY = toShareWrapped(y, totalDeposits, totalShares);

    assert x < y => toSharesX <= toSharesY;
    assert toShareWrapped(0, totalDeposits, totalShares) == 0;
    assert toShareWrapped(x, 0, 0) == x && toShareWrapped(y, 0, 0) == y;
    assert toShareWrapped(x, totalDeposits, 0) == x && toShareWrapped(y, totalDeposits, 0) == y;
    assert toShareWrapped(x, 0, totalShares) == x && toShareWrapped(y, 0, totalShares) == y;
}

rule MP_monotonicity_shares_toAmount(uint256 x, uint256 y) {
    uint256 totalDeposits;
    uint256 totalShares;

    require_totals_x_y(totalShares, totalDeposits, x, y);
    require x <= totalShares && y <= totalShares;

    uint256 toAmountX = toAmountWrapped(x, totalDeposits, totalShares);
    uint256 toAmountY = toAmountWrapped(y, totalDeposits, totalShares);

    assert  x < y => toAmountX <= toAmountY;
    assert toAmountWrapped(0, totalDeposits, totalShares) == 0;
    assert toAmountWrapped(x, 0, 0) == 0 && toAmountWrapped(y, 0, 0) == 0;
    assert toAmountWrapped(x, totalDeposits, 0) == 0 && toAmountWrapped(y, totalDeposits, 0) == 0;
    assert toAmountWrapped(x, 0, totalShares) == 0 && toAmountWrapped(y, 0, totalShares) == 0;
}

rule MP_inverse_amount(uint256 amount, uint256 totalDeposits, uint256 totalShares) {
    require_totals_amount(totalShares, totalDeposits, amount);

    uint256 shares = toShareWrapped(amount, totalDeposits, totalShares);

    uint256 totalDepositsAfer = totalDeposits + amount;
    uint256 totalSharesAfer = totalShares + shares;

    uint256 backToAmount = toAmountWrapped(shares, totalDepositsAfer, totalSharesAfer);

    assert backToAmount <= amount;
}

rule MP_inverse_shares(uint256 shares, uint256 totalDeposits, uint256 totalShares) {
    require_totals_amount(totalShares, totalDeposits, shares);
    require shares <= totalShares;

    uint256 amount = toAmountWrapped(shares, totalDeposits, totalShares);

    uint256 totalDepositsAfer = totalDeposits - amount;
    uint256 totalSharesAfer = totalShares - shares;
    
    assert (totalDepositsAfer == 0 <=> totalSharesAfer == 0);

    uint256 backToShares = toShareWrapped(amount, totalDepositsAfer, totalSharesAfer);

    assert (
            backToShares <= shares ||
            (totalDepositsAfer == 0 && backToShares == amount)
        );
}

rule RA_withdraw_with_interest(uint256 amount) {
    uint256 totalDeposits;
    uint256 totalShares;
    uint256 interest;

    require totalDeposits == totalShares;
    require totalDeposits + amount + interest < max_uint256;
    require totalDeposits != 0 && totalShares != 0 && amount != 0 && interest != 0;

    uint256 shares = toShareWrapped(amount, totalDeposits, totalShares);
    
    uint256 totalDepositsAfter = totalDeposits + amount + interest;
    uint256 totalSharesAfter = totalShares + shares;

    uint256 withdrawAmount = toAmountWrapped(shares, totalDepositsAfter, totalSharesAfter);

    assert withdrawAmount >= amount;
}
