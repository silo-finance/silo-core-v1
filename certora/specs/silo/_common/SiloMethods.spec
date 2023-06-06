methods {
    deposit(address, uint256, bool)
    depositFor(address, address, uint256, bool)
    withdraw(address, uint256, bool)
    withdrawFor(address, address, address, uint256, bool)
    borrow(address, uint256)
    borrowFor(address, address, address, uint256)
    repay(address, uint256)
    repayFor(address, address, uint256)
    accrueInterest(address)
    flashLiquidate(address[],bytes)
    harvestProtocolFees()
    initAssetsTokens()
    syncBridgeAssets()

    // Harness:
    getAssetTotalDeposits(address) returns (uint256) envfree
    getAssetCollateralOnlyDeposits(address) returns (uint256) envfree
    getAssetTotalBorrowAmount(address) returns (uint256) envfree
    getProtocolFees(address) returns (uint256) envfree
    assetStatus(address) returns (uint256) envfree
    getAssetInterestDataTimeStamp(address) returns (uint64) envfree
    getHarvestProtocolFees(address) returns (uint256) envfree
    assetIsActive(address) returns (bool) envfree
    getAssetCollateralToken(address) returns (address) envfree
    getAssetCollateralOnlyToken(address) returns (address) envfree
    getAssetDebtToken(address) returns (address) envfree
    allSiloAssetsLength() returns (uint256) envfree

    // Getters: 
    siloAsset() returns (address) envfree
    siloRepository() returns (address) envfree
    liquidity(address) returns (uint256) envfree
    isSolvent(address) returns (bool)

    // Summarizations:
    _generateSharesNames(address, bool) => NONDET
}
