// SPDX-License-Identifier: MIT
pragma solidity 0.8.13;

import "./DiaPriceProvider.sol";

contract DiaPriceProviderV2 is DiaPriceProvider {
    constructor(
        IPriceProvidersRepository _priceProvidersRepository,
        IDIAOracleV2 _diaOracle,
        address _stableAsset
    ) DiaPriceProvider(_priceProvidersRepository, _diaOracle, _stableAsset) {
    }

    /// @param _key string under this key asset price will be available in DIA oracle
    /// @return assetPriceInUsd uint128 asset price
    /// @return priceUpToDate bool TRUE if price is up to date (acceptable), FALSE otherwise
    function getPriceForKey(string memory _key)
        public
        view
        virtual
        override
        returns (uint128 assetPriceInUsd, bool priceUpToDate)
    {
        uint128 priceTimestamp;
        (assetPriceInUsd, priceTimestamp) = DIA_ORACLEV2.getValue(_key);

        // price must be updated at least once every 24h, otherwise something is wrong
        uint256 oldestAcceptedPriceTimestamp;
        // block.timestamp is more than HEARTBEAT, so we can not underflow
        unchecked { oldestAcceptedPriceTimestamp = block.timestamp - 1 days - 10 minutes; }

        // we not checking assetPriceInUsd != 0, because this is checked on setup, so it will be always some value here
        priceUpToDate = priceTimestamp > oldestAcceptedPriceTimestamp;
    }
}
