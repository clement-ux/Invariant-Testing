// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {Handler} from "test/Handler.t.sol";

contract WETHInvariants is Test {
    WETH public weth;
    Handler public handler;

    function setUp() public {
        weth = new WETH();
        handler = new Handler(address(weth));

        targetContract(address(handler));
    }

    function invariant_badInvariantThisShouldFail() public {
        assertEq(0, weth.totalSupply());
    }
}
