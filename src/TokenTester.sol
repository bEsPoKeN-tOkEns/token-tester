// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {MockERC20} from "./tokens/MockERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

// d-xo/weird-erc20
import {ApprovalRaceToken} from "weird-erc20/Approval.sol";
import {ApprovalToZeroToken} from "weird-erc20/ApprovalToZero.sol";
import {BlockableToken} from "weird-erc20/BlockList.sol";
import {ERC20 as Bytes32Metadata} from "weird-erc20/Bytes32Metadata.sol";
import {ERC20 as WeirdERC20} from "weird-erc20/ERC20.sol";
import {HighDecimalToken} from "weird-erc20/HighDecimals.sol";
import {LowDecimalToken} from "weird-erc20/LowDecimals.sol";
import {MissingReturnToken} from "weird-erc20/MissingReturns.sol";
import {NoRevertToken} from "weird-erc20/NoRevert.sol";
import {PausableToken} from "weird-erc20/Pausable.sol";
import {ProxiedToken} from "weird-erc20/Proxied.sol";
import {ReentrantToken} from "weird-erc20/Reentrant.sol";
import {ReturnsFalseToken} from "weird-erc20/ReturnsFalse.sol";
import {RevertToZeroToken} from "weird-erc20/RevertToZero.sol";
import {RevertZeroToken} from "weird-erc20/RevertZero.sol";
import {TransferFeeToken} from "weird-erc20/TransferFee.sol";
import {TransferFromSelfToken} from "weird-erc20/TransferFromSelf.sol";
import {Uint96ERC20} from "weird-erc20/Uint96.sol";
import {Proxy as Upgradable} from "weird-erc20/Upgradable.sol";

contract TokenTester is Test {
    IERC20 public testToken;

    address[] public tokens;

    constructor() {
        tokens.push(address(new MockERC20("Test", "TST", 18)));
        tokens.push(address(new WETH()));
        tokens.push(address(new ApprovalRaceToken(type(uint256).max)));
        tokens.push(address(new ApprovalToZeroToken(type(uint256).max)));
        tokens.push(address(new BlockableToken(type(uint256).max)));
        tokens.push(address(new Bytes32Metadata(type(uint256).max)));
        // TODO: look for a compiling Dai
        // tokens.push(address(new DaiPermit(type(uint256).max)));
        tokens.push(address(new WeirdERC20(type(uint256).max)));
        tokens.push(address(new HighDecimalToken(type(uint256).max)));
        tokens.push(address(new LowDecimalToken(type(uint256).max)));
        tokens.push(address(new MissingReturnToken(type(uint256).max)));
        tokens.push(address(new NoRevertToken(type(uint256).max)));
        tokens.push(address(new PausableToken(type(uint256).max)));
        tokens.push(address(new ProxiedToken(type(uint256).max)));
        tokens.push(address(new ReentrantToken(type(uint256).max)));
        tokens.push(address(new ReturnsFalseToken(type(uint256).max)));
        tokens.push(address(new RevertToZeroToken(type(uint256).max)));
        tokens.push(address(new RevertZeroToken(type(uint256).max)));
        tokens.push(address(new TransferFeeToken(type(uint256).max, 0.001 ether)));
        tokens.push(address(new TransferFromSelfToken(type(uint256).max)));
        tokens.push(address(new Uint96ERC20(type(uint96).max)));
        // TODO: figure out why its reverting on deployment
        // tokens.push(address(new Upgradable(type(uint256).max)));
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
