// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "./TokensFactoryV2.sol";
import "./utils/ShareCollateralTokenConvex.sol";
import "./lib/Ping.sol";
import "./interfaces/ISiloRepository.sol";
import "./interfaces/IConvexSiloWrapperFactory.sol";

/// @title TokensFactoryConvex deploys ShareCollateralTokenConvex for ConvexSiloWrapper Silos and regular share tokens
///     for regular Silos.
/// @notice Deploys debt and collateral tokens for each Silo
/// @custom:security-contact security@silo.finance
contract TokensFactoryConvex is TokensFactoryV2 {
    // solhint-disable-next-line var-name-mixedcase
    IConvexSiloWrapperFactory public immutable CONVEX_SILO_WRAPPER_FACTORY;

    error InvalidConvexSiloWrapperFactory();

    constructor (IConvexSiloWrapperFactory _wrapperFactory) {
        if (!Ping.pong(_wrapperFactory.convexSiloWrapperFactoryPing)) {
            revert InvalidConvexSiloWrapperFactory();
        }

        CONVEX_SILO_WRAPPER_FACTORY = _wrapperFactory;
    }

    /// @inheritdoc ITokensFactory
    function createShareCollateralToken(
        string calldata _name,
        string calldata _symbol,
        address _asset
    )
        external
        virtual
        override
        onlySilo
        returns (IShareToken token)
    {
        if (CONVEX_SILO_WRAPPER_FACTORY.isWrapper(_asset)) {
            token = new ShareCollateralTokenConvex(_name, _symbol, msg.sender, _asset);
        } else {
            token = new ShareCollateralToken(_name, _symbol, msg.sender, _asset);
        }

        emit NewShareCollateralTokenCreated(address(token));
    }
}
