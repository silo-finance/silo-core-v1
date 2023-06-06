definition depositSig() returns uint256 = deposit(address, uint256, bool).selector;
definition depositForSig() returns uint256 = depositFor(address, address, uint256, bool).selector;
definition withdrawSig() returns uint256 = withdraw(address, uint256, bool).selector;
definition withdrawForSig() returns uint256 = withdrawFor(address, address, address, uint256, bool).selector;
definition repaySig() returns uint256 = repay(address, uint256).selector;
definition repayForSig() returns uint256 = repayFor(address, address, uint256).selector;
definition borrowSig() returns uint256 = borrow(address, uint256).selector;
definition borrowForSig() returns uint256 = borrowFor(address, address, address, uint256).selector;
definition accrueInterestSig() returns uint256 = accrueInterest(address).selector;
definition flashLiquidateSig() returns uint256 = flashLiquidate(address[], bytes).selector;
definition initAssetsTokensSig() returns uint256 = initAssetsTokens().selector;
definition syncBridgeAssetsSig() returns uint256 = syncBridgeAssets().selector;
definition harvestProtocolFeesSig() returns uint256 = harvestProtocolFees().selector;