function disableInterest(env e) {
    require e.block.timestamp == getAssetInterestDataTimeStamp(siloAssetToken);
}

function disableInterestForTwoEnvs(env e1, env e2) {
    disableInterest(e1);
    disableInterest(e2);
}

function requireAmount(uint256 amount) {
    require amount > 1;
}

function basicConfig1Env(env e) {
    set_tokens();
    disableInterest(e);
}

function basicConfig2Env(env e1, env e2) {
    set_tokens();
    disableInterestForTwoEnvs(e1, e2);
}

function diff_1(uint256 b1, uint256 b2) returns bool {
    uint256 diff = b1 - b2;
    if (b1 < b2) {
        diff = b2 - b1;
    }
    
    return diff <= 1;
}
