methods {

    calculateLiquidationFee(
        uint256 _protocolEarnedFees,
        uint256 _amount,
        uint256 _liquidationFee
    ) returns (uint256 liquidationFeeAmount, uint256 newProtocolEarnedFees) envfree

    totalBorrowAmountWithInterest(
        uint256 _totalBorrowAmount,
        uint256 _rcomp
    ) returns (uint256 totalBorrowAmountWithInterests) envfree

    totalDepositsWithInterest(
        uint256 _assetTotalDeposits,
        uint256 _protocolShareFee,
        uint256 _rcomp
    ) returns (uint256 _totalDepositsWithInterests) envfree

    getUserCollateralAmount(
        address _collateralToken,
        address _collateralOnlyToken,
        uint256 _totalDeposits,
        uint256 _collateralOnlyDeposits,
        uint256 _userCollateralTokenBalance,
        uint256 _userCollateralOnlyTokenBalance,
        uint256 _rcomp,
        address _siloRepository
    ) returns (uint256) envfree

    getUserBorrowAmount(
        uint256 _totalBorrowAmount,
        address _debtToken,
        address _user,
        uint256 _rcomp
    ) returns (uint256) envfree

    // HARNESS
    convertAmountsToValues(address priceProviderRepo) returns (uint256, uint256) envfree
    getFirstAsset() returns (address) envfree
    getSecondAsset() returns (address) envfree
    getFirstAmount() returns (uint256) envfree
    getSecondAmount() returns (uint256) envfree

    balanceOfHarness(address tokenAddress, address user) returns (uint256) envfree
    totalSupplyHarness(address tokenAddress) returns (uint256) envfree

    // SIMPLIFYING
    decimals() => decimalsMocked()
    getPrice(address asset) => price(asset)
    getMaximumLTV(address silo, address asset) returns (uint256) => maximumLTVMocked()
    getLiquidationThreshold(address silo, address asset) returns (uint256) => liquidationThresholdMocked()
    getCompoundInterestRate(address silo, address asset, uint256 timestamp) returns (uint256) => rcompMocked()
    protocolShareFee() returns (uint256) => protocolShareFeeMocked()
    balanceOf(address user) returns (uint256) => PER_CALLEE_CONSTANT
    totalSupply() returns (uint256) => PER_CALLEE_CONSTANT
}

definition DP() returns uint256 = 10 ^ 18;

ghost price(address) returns uint256;

function changePrice(address t, uint newprice) {
    havoc price assuming forall address t1. t1 != t => price@new(t1)==price@old(t1) &&
    price@new(t)==newprice;
}

function decimalsMocked() returns uint256 {
    return 18;
}

function rcompMocked() returns uint256 {
    return to_uint256(2 * 10 ^ 18);
}

// 10 %
function protocolShareFeeMocked() returns uint256 {
    return to_uint256(10 * 10 ^ 18 / 100);
}

// 70%
function maximumLTVMocked() returns uint256 {
    return to_uint256(70 * 10 ^ 18 / 100);
}

// 90%
function liquidationThresholdMocked() returns uint256 {
    return to_uint256(90 * 10 ^ 18 / 100);
}
