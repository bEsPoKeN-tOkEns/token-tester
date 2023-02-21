// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {MockERC20} from "./tokens/MockERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

contract TokenTester is Test {
    IERC20 public testToken;

    address[] public tokens;

    constructor() {
        tokens.push(address(new MockERC20("Test", "TST", 18)));
        tokens.push(address(new WETH()));
    }
    
    modifier usesTokenTester() {
        uint256 i;
        for (i; i < tokens.length;) {
            testToken = IERC20(tokens[i]);
            _;
            unchecked {
                ++i;
            }
        }
    }

    modifier usesSingleToken(uint256 index) {
        testToken = IERC20(tokens[bound(index, 0, tokens.length - 1)]);
        _;
    }
}
