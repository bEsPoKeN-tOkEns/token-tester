// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Counter.sol";

type FuzzyERC20 is address;

contract TokenTester {
    modifier usesToken(FuzzyERC20 token) {
        _;
    }
}
