// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {TokenTester, FuzzyERC20} from "../src/TokenTester.sol";

contract ExampleTest is Test, TokenTester {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testDeposit(FuzzyERC20 token) public usesToken(token) {

    }

}
