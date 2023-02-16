// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {Handler} from "test/handler/Handler.t.sol";

contract WETHInvariants is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(weth);

        bytes4[] memory selectors = new bytes4[](6);
        selectors[0] = Handler.deposit.selector;
        selectors[1] = Handler.withdraw.selector;
        selectors[2] = Handler.sendFallback.selector;
        selectors[3] = Handler.approve.selector;
        selectors[4] = Handler.transfer.selector;
        selectors[5] = Handler.transferFrom.selector;

        targetSelector(FuzzSelector({
            addr: address(handler),
            selectors: selectors
        }));


        targetContract(address(handler));
    }

    function invariant_conservationOfETH() public {
        assertEq(handler.ETH_SUPPLY(), address(handler).balance + weth.totalSupply());
    }

    function invariant_solvencyDeposit() public {
        assertEq(address(weth).balance, handler.ghost_depositSum() - handler.ghost_withdrawSum());
    }

    function invariant_solvencyBalances() public {
        uint256 sumOfBalances = handler.reduceActors(
          0,
          this.accumulateBalance
        );
        assertEq(
            address(weth).balance,
            sumOfBalances
        );
    }

    function invariant_depositorBalances() public {
        handler.forEachActor(this.assertAccountBalanceLteTotalSupply);
    }

    function invariant_callSummary() public view {
        handler.callSummary();
    }

    function assertAccountBalanceLteTotalSupply(address account) external {
        assertLe(weth.balanceOf(account), weth.totalSupply());
    }

    function accumulateBalance(
      uint256 balance,
      address caller
    ) external view returns (uint256) {
        return balance + weth.balanceOf(caller);
    }
}
