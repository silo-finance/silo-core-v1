import "./../_common/SiloMethods.spec"
import "./../_common/SiloRepositoryMethods.spec"
import "./../_common/SafeMathSummarization.spec"
import "./../_common/SiloFunctionSelector.spec"
import "./../_common/IsSolventSummarization.spec"
import "./../_common/SetTokens.spec"
import "./../_common/ERC20MethodsDispatch.spec"
import "./../_common/Helpers.spec"

rule HLP_flashliquidate_shares_tokens_bal_zero(env e, address account1, address account2) {
    address someUser;
    address[] accounts;
    bytes emptyBytes;

    require emptyBytes.length == 0;

    require account1 != account2 && account1 != someUser && account2 != someUser;

    require accounts[0] == account1;
    require accounts[1] == account2;

    require isSolvent(e, account1) == false;
    require isSolvent(e, account2) == false;
    require isSolvent(e, someUser) == false;

    uint256 cBalance1Before = shareCollateralToken.balanceOf(account1);
    uint256 cBalance2Before = shareCollateralToken.balanceOf(account2);
    uint256 cBalanceSomeBefore = shareCollateralToken.balanceOf(someUser);

    uint256 coBalance1Before = shareCollateralOnlyToken.balanceOf(account1);
    uint256 coBalance2Before = shareCollateralOnlyToken.balanceOf(account2);
    uint256 coBalanceSomeBefore = shareCollateralOnlyToken.balanceOf(someUser);

    flashLiquidate(e, accounts, emptyBytes);

    bool isSolvent1After = isSolvent(e, account1);
    bool isSolvent2After = isSolvent(e, account2);
    bool isSolventSomeAfter = isSolvent(e, someUser);

    uint256 cbalance1After = shareCollateralToken.balanceOf(account1);
    uint256 cbalance2After = shareCollateralToken.balanceOf(account2);
    uint256 cbalanceSomeAfter = shareCollateralToken.balanceOf(someUser);

    uint256 coBalance1After = shareCollateralOnlyToken.balanceOf(account1);
    uint256 coBalance2After = shareCollateralOnlyToken.balanceOf(account2);
    uint256 coBalanceSomeAfter = shareCollateralOnlyToken.balanceOf(someUser);

    assert isSolvent1After && isSolvent2After => 
        cbalance1After == 0 && coBalance1After == 0 &&
        cbalance2After == 0 && coBalance2After == 0 &&
        !isSolventSomeAfter &&
        cBalanceSomeBefore == cbalanceSomeAfter &&
        coBalanceSomeBefore == coBalanceSomeAfter,
        "flashLiquidate made solvent users another than expected";
}
