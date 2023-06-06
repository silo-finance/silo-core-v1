import "./_common/methods.spec"

invariant VS_DP()
    DP() == 10 ^ 18

invariant VS_RCOMP_MAX()
    RCOMP_MAX() == (2 ^ 16) * 10 ^ 18

invariant VS_ASSET_DATA_OVERFLOW_LIMIT()
    ASSET_DATA_OVERFLOW_LIMIT() == 2 ^ 196

invariant VS_X_MAX()
    X_MAX() == 11090370147631773313

invariant VS_uopt(address silo, address asset)
    getUopt(silo, asset) > 0 && getUopt(silo, asset) < 10 ^ 18

invariant VS_ucrit(address silo, address asset)
    getUcrit(silo, asset) > getUopt(silo, asset) && getUcrit(silo, asset) < 10 ^ 18

invariant VS_ulow(address silo, address asset)
    getUlow(silo, asset) > 0 && getUlow(silo, asset) < getUopt(silo, asset)

invariant VS_ki(address silo, address asset)
    getKi(silo, asset) > 0

invariant VS_kcrit(address silo, address asset)
    getKcrit(silo, asset) > 0

invariant VS_klow(address silo, address asset)
    getKlow(silo, asset) >= 0

invariant VS_klin(address silo, address asset)
    getKlin(silo, asset) >= 0

invariant VS_beta(address silo, address asset)
    getBeta(silo, asset) >= 0

rule VS_complexInvariant_ri(address silo, address asset, method f) filtered {
         f -> !f.isView && !f.isFallback
    } {
    env e;
    calldataarg args;

    require getRi(silo, asset) >= 0;

    f(e, args);

    // getCompoundInterestRateAndUpdate case:
    // ri = _max(ri + _l.slopei * _l.T, _l.rlin); ri +_l.slopei * _l.T can be negative, but in the valid config and Silo states
    // ri will be equal to positive number _l.rlin = _c.klin * _u / _DP.

    assert getRi(silo, asset) >= 0 || 
        f.selector == getCompoundInterestRateAndUpdateSig();
}

rule VS_complexInvariant_tcrit(address silo, address asset, method f) filtered {
         f -> !f.isView && !f.isFallback
    } {
    env e;
    calldataarg args;

    require getTcrit(silo, asset) >= 0;
    require getBeta(silo, asset) >= 0;
    f(e, args);

    // getCompoundInterestRateAndUpdate case:
    // Tcrit = _max(0, Tcrit - _c.beta * _l.T) or Tcrit = Tcrit + _c.beta * _l.T (this one can become negative).
    // In a valid config and Silo state _l.T (time since last update) is a positive number, _c.beta as well. 

    assert getTcrit(silo, asset) >= 0 || 
        f.selector == getCompoundInterestRateAndUpdateSig();
}
