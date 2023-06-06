// SPDX-License-Identifier: BUSL-1.1
pragma solidity 0.8.13;

import "../../contracts/lib/Solvency.sol";
import "../../contracts/Silo.sol";

contract SolvencyHarness {
    address[] public assets;
    uint256[] public amounts;

    address[] public collateralTokens;
    address[] public collateralOnlyTokens;
    address[] public debtTokens;

    IPriceProvidersRepository public priceProviderRepo;
    ISiloRepository public siloRepository;
    ISilo public silo;


    // NOTE: we check only two assets case to be able to unroll the loops
    constructor(
        IPriceProvidersRepository _priceProviderRepo,
        ISiloRepository _siloRepository,
        ISilo _silo,
        address[] memory _assets,
        address[] memory _collateralTokens,
        address[] memory _collateralOnlyTokens,
        address[] memory _debtTokens,
        uint256 amount1,
        uint256 amount2
    ) {
        require(_assets.length == 2);
        require(_collateralTokens.length == 2);
        require(_collateralOnlyTokens.length == 2);
        require(_debtTokens.length == 2);

        priceProviderRepo = _priceProviderRepo;
        siloRepository = _siloRepository;
        silo = _silo;

        assets = _assets;
        collateralTokens = _collateralTokens;
        collateralOnlyTokens = _collateralOnlyTokens;
        debtTokens = _debtTokens;

        amounts.push(amount1);
        amounts.push(amount2);
    }

    function getFirstAsset() external view returns (address) {
        return assets[0];
    }

    function getSecondAsset() external view returns (address) {
        return assets[1];
    }

    function getFirstAmount() external view returns (uint256) {
        return amounts[0];
    }
    
    function getSecondAmount() external view returns (uint256) {
        return amounts[1];
    }

    function convertAmountsToValues(address _priceProviderRepo) external returns (uint256, uint256) {
        require(assets.length == 2 && amounts.length == 2);

        uint256[] memory values = Solvency.convertAmountsToValues(
            IPriceProvidersRepository(_priceProviderRepo), 
            assets, amounts
        );

        return (values[0], values[1]);
    }

    function calculateLTVsHarness(
        address user,
        uint256 totalDepositsFirstAsset,
        uint256 collateralOnlyDepositsFirstAsset,
        uint256 totalBorrowAmountFirstAsset,
        uint256 totalDepositsSecondAsset,
        uint256 collateralOnlyDepositsSecondAsset,
        uint256 totalBorrowAmountSecondAsset,
        uint256 LTVType
    ) external view returns (uint256, uint256) {
        return Solvency.calculateLTVs(
            packSolvencyParams(
                user,
                totalDepositsFirstAsset,
                collateralOnlyDepositsFirstAsset,
                totalBorrowAmountFirstAsset,
                totalDepositsSecondAsset,
                collateralOnlyDepositsSecondAsset,
                totalBorrowAmountSecondAsset
            ), 
            Solvency.TypeofLTV(LTVType)
        );
    }

    function balanceOfHarness(address tokenAddress, address user) external view returns(uint256) {
        return IERC20(tokenAddress).balanceOf(user);
    }

    function totalSupplyHarness(address tokenAddress) external view returns(uint256) {
        return IERC20(tokenAddress).totalSupply();
    }

    /*
    struct AssetStorage {
        IShareToken collateralToken;
        IShareToken collateralOnlyToken;
        IShareToken debtToken;
        uint256 totalDeposits;
        uint256 collateralOnlyDeposits;
        uint256 totalBorrowAmount;
    }
    */

    function packSolvencyParams(
        address user,
        uint256 totalDepositsFirstAsset,
        uint256 collateralOnlyDepositsFirstAsset,
        uint256 totalBorrowAmountFirstAsset,
        uint256 totalDepositsSecondAsset,
        uint256 collateralOnlyDepositsSecondAsset,
        uint256 totalBorrowAmountSecondAsset
    ) internal view returns (Solvency.SolvencyParams memory params) {
        uint256 collateralBalance = IERC20(collateralTokens[1]).balanceOf(user);
        uint256 collateralOnlyBalance = IERC20(collateralOnlyTokens[1]).balanceOf(user);
        uint256 debtBalance = IERC20(debtTokens[0]).balanceOf(user);
    
        require(IERC20(collateralTokens[0]).balanceOf(user) == 0);
        require(IERC20(collateralOnlyTokens[0]).balanceOf(user) == 0);
        require(debtBalance > 0);

        require(collateralBalance > 0);
        require(collateralOnlyBalance > 0);
        require(IERC20(debtTokens[1]).balanceOf(user) == 0);

        require(debtBalance == IERC20(debtTokens[0]).totalSupply());
        require(collateralBalance == IERC20(collateralTokens[1]).totalSupply());
        require(collateralOnlyBalance == IERC20(collateralOnlyTokens[1]).totalSupply());

        params.siloRepository = siloRepository;
        params.silo = silo;
        params.user = user;

        params.assets = new address[](2);
        params.assetStates = new ISilo.AssetStorage[](2);

        params.assets[0] = assets[0];
        params.assetStates[0].collateralToken = IShareToken(collateralTokens[0]);
        params.assetStates[0].collateralOnlyToken = IShareToken(collateralOnlyTokens[0]);
        params.assetStates[0].debtToken = IShareToken(debtTokens[0]);
        params.assetStates[0].totalDeposits = totalDepositsFirstAsset;
        params.assetStates[0].collateralOnlyDeposits = collateralOnlyDepositsFirstAsset;
        params.assetStates[0].totalBorrowAmount = totalBorrowAmountFirstAsset;

        params.assets[1] = assets[1];
        params.assetStates[1].collateralToken = IShareToken(collateralTokens[1]);
        params.assetStates[1].collateralOnlyToken = IShareToken(collateralOnlyTokens[1]);
        params.assetStates[1].debtToken = IShareToken(debtTokens[1]);
        params.assetStates[1].totalDeposits = totalDepositsSecondAsset;
        params.assetStates[1].collateralOnlyDeposits = collateralOnlyDepositsSecondAsset;
        params.assetStates[1].totalBorrowAmount = totalBorrowAmountSecondAsset;
    }

    function calculateLiquidationFee(uint256 _protocolEarnedFees, uint256 _amount, uint256 _liquidationFee)
        external
        pure
        returns (uint256 liquidationFeeAmount, uint256 newProtocolEarnedFees)
    {
        return Solvency.calculateLiquidationFee(_protocolEarnedFees, _amount, _liquidationFee);
    }

    function totalBorrowAmountWithInterest(uint256 _totalBorrowAmount,uint256 _rcomp)
        external
        pure 
        returns (uint256 totalBorrowAmountWithInterests) 
    {
        return Solvency.totalBorrowAmountWithInterest(_totalBorrowAmount, _rcomp);
    }

    function getUserCollateralAmount(
        address _collateralToken,
        address _collateralOnlyToken,
        uint256 _totalDeposits,
        uint256 _collateralOnlyDeposits,
        uint256 _userCollateralTokenBalance,
        uint256 _userCollateralOnlyTokenBalance,
        uint256 _rcomp,
        address _siloRepository
    ) external view returns (uint256) {
        IBaseSilo.AssetStorage memory assetStorage;
        assetStorage.collateralToken = IShareToken(_collateralToken);
        assetStorage.collateralOnlyToken = IShareToken(_collateralOnlyToken);
        assetStorage.totalDeposits = _totalDeposits;
        assetStorage.collateralOnlyDeposits = _collateralOnlyDeposits;

        return Solvency.getUserCollateralAmount(
            assetStorage,
            _userCollateralTokenBalance,
            _userCollateralOnlyTokenBalance,
            _rcomp,
            ISiloRepository(_siloRepository)
        );
    }

    function getUserBorrowAmount(uint256 _totalBorrowAmount, address _debtToken, address _user, uint256 _rcomp)
        external
        view
        returns (uint256)
    {
        IBaseSilo.AssetStorage memory assetStorage;
        assetStorage.debtToken = IShareToken(_debtToken);
        assetStorage.totalBorrowAmount = _totalBorrowAmount;

        return Solvency.getUserBorrowAmount(assetStorage, _user, _rcomp);
    }

    function totalDepositsWithInterest(uint256 _assetTotalDeposits, uint256 _protocolShareFee, uint256 _rcomp)
        external
        pure
        returns (uint256 _totalDepositsWithInterests)
    {
        return Solvency.totalDepositsWithInterest(_assetTotalDeposits, _protocolShareFee, _rcomp);
    }
}
