// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../PriceProvidersRepository.sol";
import "../interfaces/IPriceProvider.sol";

/// @dev this is MOCK contract - DO NOT USE IT!
contract MockPriceProvidersRepository is PriceProvidersRepository {
    mapping(address => uint256) public prices;

    constructor(address _quoteToken, address _factory) PriceProvidersRepository(_quoteToken, _factory) {
    }

    function setPriceProviderForAsset(address _asset, IPriceProvider _provider) external override {
        require(
            Ping.pong(_provider.priceProviderPing),
                "ProvidersRepository: not an provider"
        );

        priceProviders[_asset] = _provider;
    }

    function setPrice(address _asset, uint256 _price) public {
        prices[_asset] = _price;
    }

    function getPrice(address _asset) public view override returns (uint256) {
        return prices[_asset];
    }
}
