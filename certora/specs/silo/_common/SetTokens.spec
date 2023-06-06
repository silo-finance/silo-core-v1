using DummyERC20Asset as siloAssetToken
using ShareDebtToken as shareDebtToken
using ShareCollateralToken as shareCollateralToken
using ShareCollateralOnlyTokenHarness as shareCollateralOnlyToken
using SiloRepository as siloRepository

methods {
    shareCollateralToken.totalSupply() returns(uint256) envfree
    shareCollateralOnlyToken.totalSupply() returns(uint256) envfree
    shareDebtToken.totalSupply() returns(uint256) envfree

    shareCollateralToken.balanceOf(address) returns(uint256) envfree
    shareCollateralOnlyToken.balanceOf(address) returns(uint256) envfree
    shareDebtToken.balanceOf(address) returns(uint256) envfree
    siloAssetToken.balanceOf(address) returns(uint256) envfree

    shareCollateralToken.silo() returns(address) envfree
    shareCollateralOnlyToken.silo() returns(address) envfree
    shareDebtToken.silo() returns(address) envfree
}

function set_tokens() {
    require siloAssetToken != shareCollateralToken;
    require siloAssetToken != shareCollateralOnlyToken;
    require siloAssetToken != shareDebtToken;
    require siloAssetToken != siloRepository;
    require siloAssetToken != currentContract;

    require shareCollateralToken != shareCollateralOnlyToken;
    require shareCollateralToken != shareDebtToken;
    require shareCollateralToken != siloRepository;
    require shareCollateralToken != currentContract;

    require shareCollateralOnlyToken != shareDebtToken;
    require shareCollateralOnlyToken != siloRepository;
    require shareCollateralOnlyToken != currentContract;

    require shareDebtToken != siloRepository;
    require shareDebtToken != currentContract;

    require siloAsset() == siloAssetToken;
    require getAssetCollateralOnlyToken(siloAssetToken) == shareCollateralOnlyToken;
    require getAssetCollateralToken(siloAssetToken) == shareCollateralToken;
    require getAssetDebtToken(siloAssetToken) == shareDebtToken;
    require siloRepository() == siloRepository;

    require shareCollateralToken.silo() == currentContract;
    require shareCollateralOnlyToken.silo() == currentContract;
    require shareDebtToken.silo() == currentContract;
}
