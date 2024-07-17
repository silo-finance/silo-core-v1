// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../IndividualPriceProvider.sol";
import "./interfaces/IPPtOracle.sol";

/// @title Pendle token price provider
/// @dev https://docs.pendle.finance/Developers/Integration/PTOracle
abstract contract PendlePriceProvider is IndividualPriceProvider {
    // solhint-disable
    address public immutable PT_ORACLE;
    address public immutable MARKET;
    // solhint-enable

    uint32 public twapDuration;

    event TwapDurationUpdated(uint256 twapDuration);

    error OracleNotReady(bool increaseCardinalityRequired, bool oldestObservationSatisfied);
    error AssetNotSupported();
    error ZeroPrice();

    constructor(
        address _ptOracle,
        uint32 _twapDuration,
        address _market,
        IPriceProvidersRepository _priceProvidersRepository,
        address _asset,
        string memory _symbol
    ) IndividualPriceProvider(
        _priceProvidersRepository,
        _asset,
        _symbol
    )
    {
        PT_ORACLE = _ptOracle;
        MARKET = _market;

        _updateTwapDuration(_twapDuration);
    }

    /// @notice Allow's to update a TWAP duration
    /// @param _newTwapDuration The new TWAP duration that should be used in the price provider
    function setTwapDuration(uint32 _newTwapDuration) external virtual onlyManager() {
        _updateTwapDuration(_newTwapDuration);
    }

    /// @notice Resolve oracle state
    function getOracleState(uint32 _newTwapDuration)
        public
        view
        virtual
        returns (bool increaseCardinalityRequired, bool oldestObservationSatisfied)
    {
        (increaseCardinalityRequired, ,oldestObservationSatisfied) = IPPtOracle(PT_ORACLE)
            .getOracleState(MARKET, _newTwapDuration);
    }

    /// @notice Get PT to asset rate
    function getPtToSyRate(uint32 _twapDuration) public view virtual returns (uint256 ratePRtoEETH) {
        ratePRtoEETH = IPPtOracle(PT_ORACLE).getPtToSyRate(MARKET, _twapDuration);
    }

    /// @notice Update a TWAP duration
    /// @param _newTwapDuration The new TWAP duration that should be used in the price provider
    function _updateTwapDuration(uint32 _newTwapDuration) internal {
        (bool increaseCardinalityRequired, bool oldestObservationSatisfied) = getOracleState(_newTwapDuration);

        if (increaseCardinalityRequired || !oldestObservationSatisfied) {
            revert OracleNotReady(increaseCardinalityRequired, oldestObservationSatisfied);
        }

        twapDuration = _newTwapDuration;

        emit TwapDurationUpdated(_newTwapDuration);
    }
}
