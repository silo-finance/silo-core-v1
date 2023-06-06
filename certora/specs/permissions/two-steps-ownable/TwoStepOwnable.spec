methods {
    renounceOwnership()
    transferOwnership(address)
    transferPendingOwnership(address)
    removePendingOwnership()
    acceptOwnership()

    // getters
    owner() returns address envfree
    pendingOwner() returns address envfree
}

function not_empty_sender(env e) {
    require e.msg.sender != 0;
}

rule VC_owner_to_0(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);
    require owner() != 0;

    f(e, args);

    address ownerAfter = owner();

    assert ownerAfter == 0 => f.selector == renounceOwnership().selector,
        "An owner renounced with another method than expected";
}

rule VC_owner_update(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);

    address ownerBefore = owner();
    f(e, args);
    address ownerAfter = owner();

    assert ownerBefore != ownerAfter =>
        f.selector == transferOwnership(address).selector ||
        f.selector == renounceOwnership().selector ||
        f.selector == acceptOwnership().selector,
        "An owner updated with another method than expected";
}

rule VC_pending_owner_to_0(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);
    require pendingOwner() != 0;

    f(e, args);

    address pendingOwnerAfter = pendingOwner();

    assert pendingOwnerAfter == 0 =>
        f.selector == renounceOwnership().selector ||
        f.selector == acceptOwnership().selector ||
        f.selector == transferOwnership(address).selector ||
        f.selector == transferPendingOwnership(address).selector ||
        f.selector == removePendingOwnership().selector,
        "A pending owner set to an empty address with another method than expected";
}

rule VC_pending_owner_config(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);
    require pendingOwner() == 0;

    f(e, args);

    address pendingOwnerAfter = pendingOwner();

    assert pendingOwnerAfter != 0 =>
        f.selector == transferPendingOwnership(address).selector,
        "A pending owner set with another method than expected";
}

rule VS_empty_state(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);

    f(e, args);
    address owner = owner();
    address pendingOwner = pendingOwner();

    assert owner == 0 => pendingOwner == 0,
        "Invalid state. The owner is an empty address, but the pending owner is not";
}

rule VS_owner_update(env e, method f, calldataarg args)
    filtered { f -> !f.isView && !f.isFallback}
{
    not_empty_sender(e);
    require owner() != 0;
    require pendingOwner() != 0;

    address ownerBefore = owner();

    f(e, args);

    address ownerAfter = owner();
    address pendingOwner = pendingOwner();

    assert ownerBefore != ownerAfter => pendingOwner == 0,
        "A pending owner is not an empty address after the owner has been updated";
}

rule VS_renounceOwnership_only_owner(env e) {
    require owner() != 0;

    address ownerBefore = owner();
    renounceOwnership@withrevert(e);
    bool reverted = lastReverted;

    assert e.msg.sender != ownerBefore => reverted,
        "Another account than an owner can renounce ownership";
}

rule VS_transferOwnership_only_owner(env e, address account) {
    require owner() != 0;

    address ownerBefore = owner();
    transferOwnership@withrevert(e, account);
    bool reverted = lastReverted;

    assert e.msg.sender != ownerBefore => reverted,
        "Another account than an owner can transfer ownership";
}

rule VS_transferPendingOwnership_only_owner(env e, address account) {
    require owner() != 0;

    transferPendingOwnership@withrevert(e, account);
    bool reverted = lastReverted;

    assert e.msg.sender != owner() => reverted,
        "Another account than an owner can transfer pending ownership";
}

rule VS_removePendingOwnership_only_owner(env e) {
    require owner() != 0;

    removePendingOwnership@withrevert(e);
    bool reverted = lastReverted;

    assert e.msg.sender != owner() => reverted,
        "Another account than an owner can remove pending ownership";
}

rule VS_acceptOwnership_only_pending_owner(env e) {
    require pendingOwner() != 0;

    address pendingOwnerBefore = pendingOwner();
    acceptOwnership@withrevert(e);
    bool reverted = lastReverted;

    assert !reverted => pendingOwnerBefore == owner(),
        "A new owner is not equal to the pending owner before a call";

    assert e.msg.sender != pendingOwnerBefore => reverted,
        "Another account than a pending owner can execute acceptOwnership";
}
