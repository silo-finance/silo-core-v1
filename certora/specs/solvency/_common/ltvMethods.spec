methods {

    calculateLTVsHarness(
        address user,
        uint256 totalDepositsFirstAsset,
        uint256 collateralOnlyDepositsFirstAsset,
        uint256 totalBorrowAmountFirstAsset,
        uint256 totalDepositsSecondAsset,
        uint256 collateralOnlyDepositsSecondAsset,
        uint256 totalBorrowAmountSecondAsset,
        uint256 LTVType
    ) returns (uint256 userLTV, uint256 secondLTV)

    // HARNESS

    getFirstAsset() returns (address) envfree
    getSecondAsset() returns (address) envfree
    getFirstAmount() returns (uint256) envfree
    getSecondAmount() returns (uint256) envfree

    balanceOfHarness(address tokenAddress, address user) returns (uint256) envfree
    totalSupplyHarness(address tokenAddress) returns (uint256) envfree

    collateralTokens(uint256) returns (address) envfree
    collateralOnlyTokens(uint256) returns (address) envfree
    debtTokens(uint256) returns (address) envfree

    // SIMPLIFYING
    decimals() => decimalsMocked()
    getPrice(address asset) => price(asset)
    getMaximumLTV(address silo, address asset) returns (uint256) => maximumLTVMocked()
    getLiquidationThreshold(address silo, address asset) returns (uint256) => zeroMocked()
    getCompoundInterestRate(address silo, address asset, uint256 timestamp) returns (uint256) => zeroMocked()
    protocolShareFee() returns (uint256) => protocolShareFeeMocked()
    balanceOf(address user) returns (uint256) => PER_CALLEE_CONSTANT
    totalSupply() returns (uint256) => PER_CALLEE_CONSTANT
}

definition DP() returns uint256 = 10 ^ 18;

ghost availableToBorrow(address) returns uint256;

ghost borrowAmounts() returns uint256[];

ghost price(address) returns uint256;

function changePrice(address t, uint newprice) {
    havoc price assuming forall address t1. t1 != t => price@new(t1)==price@old(t1) &&
    price@new(t)==newprice;
}

function decimalsMocked() returns uint256 {
    return 18;
}

function zeroMocked() returns uint256 {
    return to_uint256(0);
}

// 70%
function maximumLTVMocked() returns uint256 {
    return to_uint256(70 * 10 ^ 18 / 100);
}

// 90%
function liquidationThresholdMocked() returns uint256 {
    return to_uint256(90 * 10 ^ 18 / 100);
}
