methods {
    receiveAllowance(address owner, address reciever) returns uint256 envfree

    setReceiveApproval(address owner, uint256 amount)
    decreaseReceiveAllowance(address owner, uint256 substractedValue)
    increaseReceiveAllowance(address owner, uint256 addedValue)
    transferFrom(address from, address to, uint256 amount)
}

rule VC_SharesDebt_receiveAllowances_change(method f, address owner, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    require e.msg.sender != owner;

    uint256 allowanceBefore = receiveAllowance(owner, e.msg.sender);
    f(e, args);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceBefore != allowanceAfter => (
            f.selector == setReceiveApproval(address, uint256).selector ||
            f.selector == decreaseReceiveAllowance(address, uint256).selector ||
            f.selector == increaseReceiveAllowance(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector
        ), "allowance changed as a result of function other than expected";
}

rule VC_SharesDebt_receiveAllowances_increase(method f, address owner, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    require e.msg.sender != owner;

    uint256 allowanceBefore = receiveAllowance(owner, e.msg.sender);
    f(e, args);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceBefore < allowanceAfter => (
            f.selector == setReceiveApproval(address, uint256).selector ||
            f.selector == increaseReceiveAllowance(address, uint256).selector
        ), "allowance increased as a result of function other than expected";
}

rule VC_SharesDebt_receiveAllowances_decrease(method f, address owner, uint256 amount)
    filtered { f -> !f.isView && !f.isFallback }
{
    env e;
    calldataarg args;

    require e.msg.sender != owner;

    uint256 allowanceBefore = receiveAllowance(owner, e.msg.sender);
    f(e, args);
    uint256 allowanceAfter = receiveAllowance(owner, e.msg.sender);

    assert allowanceBefore > allowanceAfter => (
            f.selector == setReceiveApproval(address, uint256).selector ||
            f.selector == decreaseReceiveAllowance(address, uint256).selector ||
            f.selector == transferFrom(address, address, uint256).selector
        ), "allowance decreased as a result of function other than expected";
}
