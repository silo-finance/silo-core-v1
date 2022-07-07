// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract MockERC20 is ERC20 {
    constructor() ERC20("mock ERC20", "mock ERC20") {
    }

    function mint(address _holder, uint256 _amount) external {
        _mint(_holder, _amount);
    }

    function burn(address _holder, uint256 amount) public {
        _burn(_holder, amount);
    }

    /// @dev our goal is not test ERC20, so let's make our life a bit easier
    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal override {
        if (from == address(0) || to == address(0)) return;

        _approve(from, to, amount);
    }

}
