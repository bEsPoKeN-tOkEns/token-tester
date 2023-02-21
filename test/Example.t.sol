// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";
import {TokenTester} from "../src/TokenTester.sol";
//import {IERC20} from "solmate/tokens/ERC20.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract ExampleTest is Test, TokenTester {
    Counter public counter;

    function setUp() public {
        counter = new Counter();
        counter.setNumber(0);
    }

    function testDeposit(address token) public usesToken(token) {
        IERC20 testToken = IERC20(token);
        assertEq(testToken.balanceOf(address(this)), 0);
    }

}
