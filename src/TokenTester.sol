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
        tokens.push(address(new ApprovalRaceToken(0)));
        tokens.push(address(new ApprovalToZeroToken(0)));
        tokens.push(address(new BlockableToken(0)));
        tokens.push(address(new Bytes32Metadata(0)));
        // TODO: look for a compiling Dai
        // tokens.push(address(new DaiPermit(0)));
        tokens.push(address(new WeirdERC20(0)));
        tokens.push(address(new HighDecimalToken(0)));
        tokens.push(address(new LowDecimalToken(0)));
        tokens.push(address(new MissingReturnToken(0)));
        tokens.push(address(new NoRevertToken(0)));
        tokens.push(address(new PausableToken(0)));
        tokens.push(address(new ProxiedToken(0)));
        tokens.push(address(new ReentrantToken(0)));
        tokens.push(address(new ReturnsFalseToken(0)));
        tokens.push(address(new RevertToZeroToken(0)));
        tokens.push(address(new RevertZeroToken(0)));
        tokens.push(address(new TransferFeeToken(0, 0.001 ether)));
        tokens.push(address(new TransferFromSelfToken(0)));
        tokens.push(address(new Uint96ERC20(0)));
        // TODO: figure out why its reverting on deployment
        // tokens.push(address(new Upgradable(0)));
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
