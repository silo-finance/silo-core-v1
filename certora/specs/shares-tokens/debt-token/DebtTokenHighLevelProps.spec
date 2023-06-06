methods {
    receiveAllowance(address owner, address reciever) returns uint256 envfree

    setReceiveApproval(address owner, uint256 amount)
    decreaseReceiveAllowance(address owner, uint256 substractedValue)
    increaseReceiveAllowance(address owner, uint256 addedValue)
}

rule HLP_SharesDebt_additive_decreaseReceiveAllowance(method f) {
    env e;
    address owner; uint256 amount1; uint256 amount2;

    require e.msg.sender != owner;
    require amount1 + amount2 <= receiveAllowance(owner, e.msg.sender);

    storage initialStorage = lastStorage;

    decreaseReceiveAllowance(e, owner, amount1);
    decreaseReceiveAllowance(e, owner, amount2);

    uint256 allowance1 = receiveAllowance(owner, e.msg.sender);

    decreaseReceiveAllowance(e, owner, amount1 + amount2) at initialStorage;

    uint256 allowance2 = receiveAllowance(owner, e.msg.sender);

    assert allowance1 == allowance2, "decreaseReceiveAllowance# is not additive";
}

rule HLP_SharesDebt_additive_increaseAllowance(method f) {
    env e;
    address owner; uint256 amount1; uint256 amount2;

    require e.msg.sender != owner;
    require amount1 + amount2 + receiveAllowance(owner, e.msg.sender) < max_uint256;

    storage initialStorage = lastStorage;

    increaseReceiveAllowance(e, owner, amount1);
    increaseReceiveAllowance(e, owner, amount2);

    uint256 allowance1 = receiveAllowance(owner, e.msg.sender);

    increaseReceiveAllowance(e, owner, amount1 + amount2) at initialStorage;

    uint256 allowance2 = receiveAllowance(owner, e.msg.sender);

    assert allowance1 == allowance2, "increaseReceiveAllowance# is not additive";
}

rule HLP_SharesDebt_integrity_setReceiveApproval(method f) {
    env e;
    address owner; uint256 amount;

    require e.msg.sender != owner;

    setReceiveApproval(e, owner, amount);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceAfter == amount, "integrity break setReceiveApproval#";
}

rule HLP_SharesDebt_integrity_decreaseReceiveAllowance(method f) {
    env e;
    address owner; uint256 amount;

    require e.msg.sender != owner;
    require amount <= receiveAllowance(owner, e.msg.sender);

    uint256 allowanceBefore = receiveAllowance(owner, e.msg.sender);
    decreaseReceiveAllowance(e, owner, amount);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceAfter == allowanceBefore - amount,
        "integrity break decreaseReceiveAllowance#";
}

rule HLP_SharesDebt_integrity_increaseReceiveAllowance(method f) {
    env e;
    address owner; uint256 amount;

    require e.msg.sender != owner;
    require amount + receiveAllowance(owner, e.msg.sender) < max_uint256;

    uint256 allowanceBefore = receiveAllowance(owner, e.msg.sender);
    increaseReceiveAllowance(e, owner, amount);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceAfter == allowanceBefore + amount,
        "integrity break increaseReceiveAllowance#";
}
