// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {TokenTester} from "../src/TokenTester.sol";

contract ExampleTest is Test, TokenTester {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testZero() public usesTokenTester {
        assertEq(testToken.balanceOf(address(this)), 0);
    }

    function testTransfer(uint256 amount, uint256 index) public usesSingleToken(index) {
        deal(address(testToken), address(this), amount);
        testToken.transfer(address(0xBEEF), amount);
        assertEq(testToken.balanceOf(address(this)), 0);
    }
}
