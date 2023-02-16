// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.17;

import {Test} from "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";

contract Handler is Test {
    WETH public weth;

    constructor(WETH _weth) {
        weth = _weth;
        deal(address(this), 10 ether);
    }

    function deposit(uint256 amount) public {
        weth.deposit{value: amount}();
    }
}