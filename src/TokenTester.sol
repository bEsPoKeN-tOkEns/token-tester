// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {MockERC20} from "./tokens/MockERC20.sol";

contract TokenTester is Test {
    // IERC20 public token;

    address[] public tokens;

    constructor() {
        tokens.push(address(new MockERC20("Test", "TST", 18)));
    }
    
    modifier usesTokenTester() {
        uint256 i;
        for (i; i < tokens.length;) {
            _;
            unchecked {
                ++i;
            }
        }
    }
}
