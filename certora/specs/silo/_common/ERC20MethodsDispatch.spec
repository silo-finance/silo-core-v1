methods {
    transferFrom(address, address, uint) => DISPATCHER(true)
    transfer(address, uint) => DISPATCHER(true)
    balanceOf(address) returns (uint) => DISPATCHER(true)
    totalSupply() returns (uint) => DISPATCHER(true)
    mint(address, uint256) => DISPATCHER(true)
    burn(address, uint256) => DISPATCHER(true)
    decimals() returns (uint) => DISPATCHER(true)
}
