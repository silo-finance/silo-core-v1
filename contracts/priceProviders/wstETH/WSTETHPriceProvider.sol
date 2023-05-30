// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../IndividualPriceProvider.sol";
import "./../../lib/TokenHelper.sol";

interface IStETHLike {
    function getPooledEthByShares(uint256 _sharesAmount) external view returns (uint256);
}

/// @title WSTETHPriceProvider
/// @notice WSTETHPriceProvider is the price provider for wstETH token. Price calculations depends
/// on the price of stETH. Price providers repository must be ready to provide the stETH price.
/// @custom:security-contact security@silo.finance
contract WSTETHPriceProvider is IndividualPriceProvider {
    // solhint-disable-next-line var-name-mixedcase
    IStETHLike public immutable STETH;

    error AssetNotSupported();
    error InvalidSTETHAddress();
    error InvalidWSTETHAddress();

    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IStETHLike _stETH,
        address _wstETH
    ) IndividualPriceProvider(_priceProvidersRepository, _wstETH, "wstETH") {
        if (keccak256(abi.encode(TokenHelper.symbol(address(_stETH)))) != keccak256(abi.encode("stETH"))) {
            revert InvalidSTETHAddress();
        }

        STETH = _stETH;
    }

    /// @inheritdoc IPriceProvider
    function getPrice(address _asset) public view virtual override returns (uint256 price) {
        if (!assetSupported(_asset)) revert AssetNotSupported();

        // solhint-disable-next-line var-name-mixedcase
        uint256 ETHPerStETH = priceProvidersRepository.getPrice(address(STETH));

        uint256 stETHPerWstETH = STETH.getPooledEthByShares(1 ether);

        // Amount of ETH per stETH * Amount of stETH per wstETH = Amount of ETH per wstETH
        return ETHPerStETH * stETHPerWstETH / 1e18;
    }
}
