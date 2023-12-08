// SPDX-License-Identifier: BUSL-1.1
pragma solidity ^0.8.13;

import "../IndividualPriceProvider.sol";
import "./../../lib/TokenHelper.sol";

interface IStEURLike {
    function convertToAssets(uint256 _sharesAmount) external view returns (uint256);
}

/// @title STEURETHPriceProvider
/// @notice STEURETHPriceProvider is the price provider for stEUR token. Price calculations depends
/// on the price of agEUR. Price providers repository must be ready to provide the EUR price.
/// @custom:security-contact security@silo.finance
contract STEURETHPriceProvider is IndividualPriceProvider {
    // solhint-disable-next-line var-name-mixedcase
    IStEURLike public immutable STEUR;

    address public immutable EUR_ASSET;

    uint8 internal constant _QUOTE_TOKEN_DECIMALS = 18; // solhint-disable-line var-name-mixedcase

    event NewAggregator(AggregatorV3Interface indexed aggregator);
    event NewHeartbeat(uint256 heartbeat);

    error AggregatorDidNotChange();
    error AggregatorPriceNotAvailable();
    error AssetNotSupported();
    error HeartbeatDidNotChange();
    error InvalidAddress();
    error InvalidAggregator();
    error InvalidHeartbeat();
    error InvalidSTEURAddress();

    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IStEURLike _stEUR,
        address eurAsset,
        uint256 _heartbeat,
        AggregatorV3Interface _aggregator
    ) IndividualPriceProvider(_priceProvidersRepository, _stEUR, "stEUR") {
        if (keccak256(abi.encode(TokenHelper.symbol(address(_stEUR)))) != keccak256(abi.encode("stEUR"))) {
            revert InvalidSTEURAddress();
        }
        if(eurAsset == address(0)) revert InvalidAddress();
        EUR_ASSET = eurAsset;
        STEUR = _stEUR;
        _setHeartbeat(_heartbeat);
        _setAggregator(_aggregator);
    }

    /// @inheritdoc IPriceProvider
    function getPrice(address _asset) public view virtual override returns (uint256 price) {
        if (!assetSupported(_asset)) revert AssetNotSupported();
        uint256 ethPerEUR = priceProvidersRepository.getPrice(EUR_ASSET);
        uint256 agEURPerStEUR = STEUR.convertToAssets(1 ether);
        (bool success, uint256 EURPerAgEUR) = _getAggregatorPrice(_asset);
        if(!success) revert InvalidPrice();
        return agEURPerStEUR * EURPerAgEUR * ethPerEUR / 1e36;
    }

    /// @dev Sets the aggregator and heartbeat for agEUR/EUR. Can only be called by the manager.
    /// @param _aggregator Chainlink aggregator proxy
    /// @param _heartbeat Threshold in seconds to invalidate a stale price
    function setupAsset(
        AggregatorV3Interface _aggregator,
        uint256 _heartbeat
    ) external onlyManager {
        // This has to be done first so that `_setAggregator` works
        _setHeartbeat(_heartbeat);
        _setAggregator(_aggregator);
    }

    /// @dev Sets the aggregator for agEUR/EUR. Can only be called by the manager.
    /// @param _aggregator Aggregator to set
    function setAggregator(AggregatorV3Interface _aggregator) external onlyManager {
        _setAggregator(_aggregator);
    }

    /// @dev Sets the heartbeat threshold for agEUR/EUR. Can only be called by the manager.
    /// @param _heartbeat Threshold to set
    function setHeartbeat(uint256 _heartbeat) external onlyManager {
        _setHeartbeat(_heartbeat);
    }

    function _getAggregatorPrice() internal view virtual returns (bool success, uint256 price) {
        uint256 _heartbeat = heartbeat;
        AggregatorV3Interface _aggregator = aggregator;
        if (address(_aggregator) == address(0)) revert AssetNotSupported();

        (
            /*uint80 roundID*/,
            int256 aggregatorPrice,
            /*uint256 startedAt*/,
            uint256 timestamp,
            /*uint80 answeredInRound*/
        ) = _aggregator.latestRoundData();

        // If a valid price is returned and it was updated recently
        if (_isValidPrice(aggregatorPrice, timestamp, heartbeat)) {
            uint8 aggregatorDecimals = _aggregator.decimals();
            result = _normalizeWithDecimals(uint256(aggregatorPrice), aggregatorDecimals);
            return (true, result);
        }

        return (false, 0);
    }

    function _setAggregator(
        AggregatorV3Interface _aggregator
    ) internal virtual returns (bool changed) {
        if (address(_aggregator) == address(0)) revert InvalidAggregator();
        if (aggregator == _aggregator) revert AggregatorDidNotChange();
        
        // There doesn't seem to be a way to verify if this is a "valid" aggregator (other than getting the price)
        aggregator = _aggregator;
        (bool success,) = _getAggregatorPrice(_asset);
        if (!success) revert AggregatorPriceNotAvailable();
        emit NewAggregator(_aggregator);
        return true;
    }

    function _setHeartbeat(uint256 _heartbeat) internal virtual returns (bool changed) {
        // Arbitrary limit, Chainlink's threshold is always less than a day
        if (_heartbeat > 2 days) revert InvalidHeartbeat();
        if (_heartbeat == heartbeat) return HeartbeatDidNotChange();
    
        heartbeat = _heartbeat;

        emit NewHeartbeat(_heartbeat);

        return true;
    }

    /// @dev Adjusts the given price to use the same decimals as the quote token.
    /// @param _price Price to adjust decimals
    /// @param _decimals Decimals considered in `_price`
    function _normalizeWithDecimals(uint256 _price, uint8 _decimals) internal view virtual returns (uint256) {
        // We want to return the price of 1 asset token, but with the decimals of the quote token
        if (_QUOTE_TOKEN_DECIMALS == _decimals) {
            return _price;
        } else if (_QUOTE_TOKEN_DECIMALS < _decimals) {
            return _price / 10 ** (_decimals - _QUOTE_TOKEN_DECIMALS);
        } else {
            return _price * 10 ** (_QUOTE_TOKEN_DECIMALS - _decimals);
        }
    }

    function _isValidPrice(int256 _price, uint256 _timestamp, uint256 _heartbeat) internal view virtual returns (bool) {
        return _price > 0 && block.timestamp - _timestamp < _heartbeat;
    }
}
