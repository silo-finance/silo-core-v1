import "./_common/methods.spec"

rule VCH_uoptChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 uoptBefore = getUopt(silo, asset);

    f(e, args);

    int256 uoptAfter = getUopt(silo, asset);
    address owner = owner(e);

    assert uoptAfter != uoptBefore => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_ucritChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 ucritBefore = getUcrit(silo, asset);

    f(e, args);

    int256 ucritAfter = getUcrit(silo, asset);
    address owner = owner(e);

    assert ucritAfter != ucritBefore => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_ulowChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 ulowBefore = getUlow(silo, asset);

    f(e, args);

    int256 ulowAfter = getUlow(silo, asset);
    address owner = owner(e);

    assert ulowAfter != ulowBefore => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_kiChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 kiBefore = getKi(silo, asset);

    f(e, args);

    int256 kiAfter = getKi(silo, asset);
    address owner = owner(e);

    assert kiBefore != kiAfter => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_kcritChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 kcritBefore = getKcrit(silo, asset);

    f(e, args);

    int256 kcritAfter = getKcrit(silo, asset);
    address owner = owner(e);

    assert kcritBefore != kcritAfter => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_klowChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 klowBefore = getKlow(silo, asset);

    f(e, args);

    int256 klowAfter = getKlow(silo, asset);
    address owner = owner(e);

    assert klowBefore != klowAfter => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_klinChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 klinBefore = getKlin(silo, asset);

    f(e, args);

    int256 klinAfter = getKlin(silo, asset);
    address owner = owner(e);

    assert klinBefore != klinAfter => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_betaChangedOnlyOwner(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 betaBefore = getBeta(silo, asset);

    f(e, args);

    int256 betaAfter = getBeta(silo, asset);
    address owner = owner(e);

    assert betaBefore != betaAfter => (f.selector == setConfigSig() && e.msg.sender == owner);
}

rule VCH_riChangedOnlyOwnerOrInterestUpdate(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 riBefore = getRi(silo, asset);

    f(e, args);

    int256 riAfter = getRi(silo, asset);
    address owner = owner(e);

    assert riBefore != riAfter => (
        e.msg.sender == owner && f.selector == setConfigSig() ||
        e.msg.sender == silo && f.selector == getCompoundInterestRateAndUpdateSig()
    );
}

rule VCH_tcritChangedOnlyOwnerOrInterestUpdate(address silo, address asset, method f) {
    env e;
    calldataarg args;

    int256 tcritBefore = getTcrit(silo, asset);

    f(e, args);

    int256 tcritAfter = getTcrit(silo, asset);
    address owner = owner(e);

    assert tcritBefore != tcritAfter => (
        e.msg.sender == owner && f.selector == setConfigSig() ||
        e.msg.sender == silo && f.selector == getCompoundInterestRateAndUpdateSig()
    );
}
