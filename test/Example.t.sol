// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";

import {ERC20} from "solmate/tokens/ERC20.sol";
import {TokenTester} from "../src/TokenTester.sol";
import {MyContract} from "./mocks/MyContract.sol";

contract ExampleTest is Test, TokenTester {
    address alice = makeAddr("ALICE");
    MyContract vault;

    function setUp() public {}

    function testZeroBalance() public usesERC20TokenTester {
        // showcase how to use `tokenTest` in a totally useless test
        vault = new MyContract(ERC20(address(tokenTest)));
        assertEq(tokenTest.balanceOf(address(this)), 0);
    }

    function testDeposit() public usesERC20TokenTester {
        vault = new MyContract(ERC20(address(tokenTest)));
        deal(address(tokenTest), alice, 100);

        vm.startPrank(alice);
        tokenTest.approve(address(vault), 100);
        vault.deposit(100, alice);
        vm.stopPrank();

        // if successful, alice owns ERC4626 vault tokens
        assertEq(vault.balanceOf(alice) != 0, true);
    }

    function testWithdraw() public usesERC20TokenTester {
        vault = new MyContract(ERC20(address(tokenTest)));
        deal(address(tokenTest), alice, 100);

        vm.startPrank(alice);
        tokenTest.approve(address(vault), 100);
        vault.deposit(100, alice);
        vm.stopPrank();

        vm.startPrank(alice);
        vault.redeem(vault.balanceOf(alice), alice, alice);
        vm.stopPrank();

        // if successful, alice does not own ERC4626 vault tokens
        assertEq(vault.balanceOf(alice) == 0, true);

        // alice now owns 100 ERC20 tokens
        assertEq(tokenTest.balanceOf(alice), 100);
    }
}
