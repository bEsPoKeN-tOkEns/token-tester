// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {TokenTester} from "../src/TokenTester.sol";

contract ExampleTest is Test, TokenTester {

    function setUp() public {

    }

    function testZero() public usesTokenTester {
        assertEq(testToken.balanceOf(address(this)), 0);
    }

    function testTransfer(uint256 amount, uint256 index) public usesSingleToken(index) {
        vm.assume(amount < type(uint96).max);
        deal(address(testToken), address(this), amount);
        testToken.transfer(address(0xBEEF), amount);
        assertEq(testToken.balanceOf(address(this)), 0);
    }
}
