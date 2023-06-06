definition setupAssetSig() returns uint256 = setupAsset(address, address, address, uint256, bool).selector;
definition setHeartbeatSig() returns uint256 = setHeartbeat(address, uint256).selector;
definition setAggregatorSig() returns uint256 = setAggregator(address, address, bool).selector;
definition setFallbackPriceProviderSig() returns uint256 = setFallbackPriceProvider(address, address).selector;
definition setEmergencyManagerSig() returns uint256 = setEmergencyManager(address).selector;
definition emergencyDisableSig() returns uint256 = emergencyDisable(address).selector;
