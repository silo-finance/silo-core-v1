using InterestRateModelHarness as interestRateModel

methods {
    DP() envfree
    RCOMP_MAX() envfree
    X_MAX() envfree
    ASSET_DATA_OVERFLOW_LIMIT() envfree
    getCompoundInterestRateAndUpdate(address, uint256) returns (uint256)
    getCompoundInterestRate(address, address, uint256) returns (uint256) envfree
    overflowDetected(address, address, uint256) returns (bool) envfree

    calculateCompoundInterestRateWithOverflowDetection(
        interestRateModel.Config config,
        uint256 _totalDeposits,
        uint256 _totalBorrowAmount,
        uint256 _interestRateTimestamp,
        uint256 _blockTimestamp
    ) returns (uint256, int256, int256, bool)

    // HARNESS
    maxHarness(int256, int256) returns (int256) envfree
    minHarness(int256, int256) returns (int256) envfree
    getUopt(address, address) returns (int256) envfree
    getUcrit(address, address) returns (int256) envfree
    getUlow(address, address) returns (int256) envfree
    getKi(address, address) returns (int256) envfree
    getKcrit(address, address) returns (int256) envfree
    getKlow(address, address) returns (int256) envfree
    getKlin(address, address) returns (int256) envfree
    getBeta(address, address) returns (int256) envfree
    getRi(address, address) returns (int256) envfree
    getTcrit(address, address) returns (int256) envfree
    calculateUtilization(uint256, uint256) returns (uint256) envfree
}

definition setConfigSig() returns uint256 = setConfig(address,address,(int256,int256,int256,int256,int256,int256,int256,int256,int256,int256)).selector;

definition getCompoundInterestRateAndUpdateSig() returns uint256 = getCompoundInterestRateAndUpdate(address, uint256).selector;
