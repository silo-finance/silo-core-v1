function SFSWithInterest(
    method f,
    address asset,
    address depositor,
    address receiver,
    address borrower,
    bool collateralOnly,
    uint256 amount
) {
    env e;
    require getAssetInterestDataTimeStamp(asset) != 0;
    require e.block.timestamp > getAssetInterestDataTimeStamp(asset);

    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInterestWithEnv(
    env e,
    method f,
    address asset,
    address depositor,
    address receiver,
    address borrower,
    bool collateralOnly,
    uint256 amount
) {
    require getAssetInterestDataTimeStamp(asset) != 0;
    require e.block.timestamp > getAssetInterestDataTimeStamp(asset);

    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterest(
    method f,
    address asset,
    address depositor,
    address receiver,
    address borrower,
    bool collateralOnly,
    uint256 amount
) {
    env e;

    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInterestWithInputs(method f, address asset) {
    address depositor; address receiver; address borrower; bool collateralOnly; uint256 amount;
    SFSWithInterest(f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInterestWithAmount(method f, address asset, uint256 amount) {
    address depositor; address receiver; address borrower; bool collateralOnly;
    SFSWithInterest(f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInterestCollateralOnly(method f, address asset, bool collateralOnly) {
    address depositor; address receiver; address borrower; uint256 amount;
    SFSWithInterest(f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInterestCOAmount(method f, address asset, bool collateralOnly, uint256 amount) {
    address depositor; address receiver; address borrower;
    SFSWithInterest(f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithInputs(method f, address asset) {
    env e;

    address depositor; address receiver; address borrower; bool collateralOnly; uint256 amount;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithAmount(method f, address asset, uint256 amount) {
    env e;

    address depositor; address receiver; address borrower; bool collateralOnly;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithCOAmount(method f, address asset, bool collateralOnly, uint256 amount) {
    env e;

    address depositor; address receiver; address borrower;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithCollateralOnly(method f, address asset, bool collateralOnly) {
    env e;

    address depositor; address receiver; address borrower; uint256 amount;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithAmountCollateralOnly(method f, address asset, uint256 amount, bool collateralOnly) {
    env e;

    address depositor; address receiver; address borrower;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithoutInterestWithEnv(env e, method f, address asset) {
    address depositor; address receiver; address borrower; bool collateralOnly; uint256 amount;
    require e.block.timestamp == getAssetInterestDataTimeStamp(asset);
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFSWithInputs(env e, method f, address asset) {
    address depositor; address receiver; address borrower; bool collateralOnly; uint256 amount;
    SFS(e, f, asset, depositor, receiver, borrower, collateralOnly, amount);
}

function SFS(
    env e,
    method f,
    address asset,
    address depositor,
    address receiver,
    address borrower,
    bool collateralOnly,
    uint256 amount
) {
    require e.block.timestamp < max_uint64;
    require amount > 1;

    if (f.selector == deposit(address, uint256, bool).selector ) {
        deposit(e, asset, amount, collateralOnly);
    } else if (f.selector == withdraw(address, uint256, bool).selector) {
        withdraw(e, asset, amount, collateralOnly);
    } else if (f.selector == depositFor(address, address, uint256, bool).selector) {
        depositFor(e, asset, depositor, amount, collateralOnly);
    } else if (f.selector == withdrawFor(address, address, address, uint256, bool).selector){
        withdrawFor(e, asset, depositor, receiver, amount, collateralOnly);
    } else if (f.selector == borrow(address, uint256).selector) {
        borrow(e, asset, amount);
    } else if (f.selector == borrowFor(address, address, address, uint256).selector) {
        borrowFor(e, asset, borrower, receiver, amount);
    } else if (f.selector == repay(address, uint256).selector) {
        repay(e, asset, amount);
    } else if (f.selector == repayFor(address, address, uint256).selector) {
        repayFor(e, asset, borrower, amount);
    } else if (f.selector == accrueInterest(address).selector) {
        accrueInterest(e, asset);
    } else if (f.selector == flashLiquidate(address[],bytes).selector) {
        bytes emptyBytes;
        require emptyBytes.length == 0;

        address[] accounts; address account1; address account2;
        require account1 != account2;
        require accounts[0] == account1;
        require accounts[1] == account2;

        flashLiquidate(e, accounts, emptyBytes);
    } else {
        calldataarg args;
        f(e, args);
    }
}
