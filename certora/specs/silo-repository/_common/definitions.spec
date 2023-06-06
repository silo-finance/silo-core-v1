definition oneHundredPercent() returns uint256 = 10 ^ 18;

definition setDefaultLiquidationThresholdSig() returns uint256 = setDefaultLiquidationThreshold(uint64).selector;
definition setDefaultMaximumLTVSig() returns uint256 = setDefaultMaximumLTV(uint64).selector;
definition setDefaultInterestRateModelSig() returns uint256 = setDefaultInterestRateModel(address).selector;
definition setPriceProvidersRepositorySig() returns uint256 = setPriceProvidersRepository(address).selector;
definition setRouterSig() returns uint256 = setRouter(address).selector;
definition setNotificationReceiverSig() returns uint256 = setNotificationReceiver(address, address).selector;
definition setTokensFactorySig() returns uint256 = setTokensFactory(address).selector;
definition addBridgeAssetSig() returns uint256 = addBridgeAsset(address).selector;
definition removeBridgeAssetSig() returns uint256 = removeBridgeAsset(address).selector;
definition registerSiloVersionSig() returns uint256 = registerSiloVersion(address, bool).selector;
definition unregisterSiloVersionSig() returns uint256 = unregisterSiloVersion(uint128).selector;
definition setDefaultSiloVersionSig() returns uint256 = setDefaultSiloVersion(uint128).selector;
