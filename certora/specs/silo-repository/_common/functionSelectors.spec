function SRFSTokensFactory(
     env e,
     method f,
     address factory
 ) {
     if (f.selector == setTokensFactorySig()) {
         setTokensFactory(e, factory);
     } else {
         calldataarg args;
         f(e, args);
     }
 }

function SRFSNotificationReceiver(
     env e,
     method f,
     address silo,
     address receiver
 ) {
     if (f.selector == setNotificationReceiverSig()) {
         setNotificationReceiver(e, silo, receiver);
     } else {
         calldataarg args;
         f(e, args);
     }
 }

function SRFSBridgeAssets(
     env e,
     method f,
     address asset
 ) {
     if (f.selector == addBridgeAssetSig()) {
         addBridgeAsset(e, asset);
     } else if (f.selector == removeBridgeAssetSig()) {
         removeBridgeAsset(e, asset);
     } else {
         calldataarg args;
         f(e, args);
     }
 }

 function SRFSSiloVersion(
     env e,
     method f,
     address asset,
     bool isDefault,
     uint128 siloVersion
 ) {
     if (f.selector == registerSiloVersionSig()) {
        registerSiloVersion(e, asset, isDefault);
     } else if (f.selector == setDefaultSiloVersionSig()) {
        setDefaultSiloVersion(e, siloVersion);
     } else if (f.selector == unregisterSiloVersionSig()) {
        unregisterSiloVersion(e, siloVersion);
     } else {
         calldataarg args;
         f(e, args);
     }
 }
