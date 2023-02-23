// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {TokenTester} from "../src/TokenTester.sol";

contract ExampleTest is Test, TokenTester {
    function setUp() public {}

    function testZeroAssertions() public usesTokenTester {
        assertEq(tokenTest.balanceOf(address(this)), 0);
    }

    function testToken_foo() public usesTT {
        assertEq(true, true);
    }

    function testToken_bar() public usesTT {}

    function testTransfer(uint256 amount, uint256 index) public usesSingleToken(index) {
        vm.assume(amount < type(uint96).max);
        deal(address(tokenTest), address(this), amount);
        tokenTest.transfer(address(0xBEEF), amount);
        assertEq(tokenTest.balanceOf(address(this)), 0);
    }
}
