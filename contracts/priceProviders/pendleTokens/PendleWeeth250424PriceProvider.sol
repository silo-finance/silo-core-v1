// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./PendlePriceProvider.sol";

contract PendleWeeth250424PriceProvider is PendlePriceProvider {
  address public constant WEETH = 0x35751007a407ca6FEFfE80b3cB397736D2cf4dbe;

  constructor(
        address _ptOracle,
        uint32 _twapDuration,
        address _market,
        IPriceProvidersRepository _priceProvidersRepository,
        address _asset,
        string memory _symbol
    ) PendlePriceProvider(
        _ptOracle,
        _twapDuration,
        _market,
        _priceProvidersRepository,
        _asset,
        _symbol
    ) {}

    function getPrice(address _asset) public view virtual returns (uint256 price) {
        if (!assetSupported(_asset)) revert AssetNotSupported();

        // Pendle PT-weETH-25APR2024/weETH conversion rate
        uint256 ratePTtoWEETH = getPtToSyRate(twapDuration);

        // Uniswap weETH/ETH price
        uint256 weETHPrice = priceProvidersRepository.getPrice(WEETH);

        price = weETHPrice * ratePTtoWEETH;
        unchecked { price = price / 1e18; }

        // Zero price is unacceptable
        if (price == 0) revert ZeroPrice();
    }
}
