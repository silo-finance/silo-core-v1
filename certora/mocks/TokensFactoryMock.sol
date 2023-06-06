// SPDX-License-Identifier: BUSL-1.1
import "../../contracts/Silo.sol";
import "../../contracts/interfaces/IShareToken.sol";

/// @dev Don't try to find any sense of it from the solidity perspective.
/// @dev It is hard to work with a 'new' statement in Certora. It returned similar addresses
/// @dev for share collateral and share collateral only or debt tokens.
/// @dev Treat it like a workaround only for Certora tests for Silo functions like:
/// @dev initAssetsTokens() and syncBridgeAssets().
contract TokensFactoryMock is ITokensFactory {
    uint nextNew = 1;

    mapping (uint => IShareToken) newContracts;
    mapping (IShareToken => uint) uniqueness;

    function initRepository(address _siloRepository) external override {}
    function tokensFactoryPing() external override pure returns (bytes4) {
        return this.tokensFactoryPing.selector;
    }

    /// @inheritdoc ITokensFactory
    function createShareCollateralToken(
        string memory _name,
        string memory _symbol,
        address _asset
    )
        external
        override
        returns (IShareToken)
    {
        return _createToken();
    }

    function createShareDebtToken(
        string memory _name,
        string memory _symbol,
        address _asset
    )
        external
        override
        returns (IShareToken)
    {
        return _createToken();
    }

    function _createToken() internal returns (IShareToken) {
        IShareToken token = newContracts[nextNew];
        // we can safely assume that it is a new one
        require (address(token) != address(0x00));
        require (uniqueness[token] == nextNew);
        //get ready for the next call
        nextNew++;
        return token;
    }
}
