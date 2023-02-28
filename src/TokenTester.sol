// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {BaseERC20} from "./tokens/BaseERC20.sol";
import {IERC20} from "openzeppelin-contracts/token/ERC20/IERC20.sol";
import {Strings} from "openzeppelin-contracts/utils/Strings.sol";

// d-xo/weird-erc20
import {ApprovalRaceToken} from "weird-erc20/Approval.sol";
import {ApprovalToZeroToken} from "weird-erc20/ApprovalToZero.sol";
import {BlockableToken} from "weird-erc20/BlockList.sol";
import {ERC20 as Bytes32Metadata} from "weird-erc20/Bytes32Metadata.sol";
import {DaiPermit} from "weird-erc20/DaiPermit.sol";
import {ERC20 as WeirdERC20} from "weird-erc20/ERC20.sol";
import {HighDecimalToken} from "weird-erc20/HighDecimals.sol";
import {LowDecimalToken} from "weird-erc20/LowDecimals.sol";
import {MissingReturnToken} from "weird-erc20/MissingReturns.sol";
import {NoRevertToken} from "weird-erc20/NoRevert.sol";
import {PausableToken} from "weird-erc20/Pausable.sol";
import {ProxiedToken, TokenProxy} from "weird-erc20/Proxied.sol";
import {ReentrantToken} from "weird-erc20/Reentrant.sol";
import {ReturnsFalseToken} from "weird-erc20/ReturnsFalse.sol";
import {RevertToZeroToken} from "weird-erc20/RevertToZero.sol";
import {RevertZeroToken} from "weird-erc20/RevertZero.sol";
import {TransferFeeToken} from "weird-erc20/TransferFee.sol";
import {TransferFromSelfToken} from "weird-erc20/TransferFromSelf.sol";
import {Uint96ERC20} from "weird-erc20/Uint96.sol";
import {Proxy as Upgradable} from "weird-erc20/Upgradable.sol";

contract TokenTester is Test {
    IERC20 public tokenTest;

    address[] public tokens;
    string[] public tokenNames;
    string public tokenNameStr;

    constructor() {
        tokens.push(address(new BaseERC20("Test", "TST", 18)));
        tokenNames.push("BaseERC20");

        tokens.push(address(new WETH()));
        tokenNames.push("WETH");

        tokens.push(address(new ApprovalRaceToken(0)));
        tokenNames.push("Approval");

        tokens.push(address(new ApprovalToZeroToken(0)));
        tokenNames.push("ApprovalToZero");

        tokens.push(address(new BlockableToken(0)));
        tokenNames.push("BlockList");

        tokens.push(address(new Bytes32Metadata(0)));
        tokenNames.push("Bytes32Metadata");

        tokens.push(address(new DaiPermit(0)));
        tokenNames.push("DaiPermit");

        tokens.push(address(new WeirdERC20(0)));
        tokenNames.push("WeirdERC20");

        tokens.push(address(new HighDecimalToken(0)));
        tokenNames.push("HighDecimals");

        tokens.push(address(new LowDecimalToken(0)));
        tokenNames.push("LowDecimals");

        tokens.push(address(new MissingReturnToken(0)));
        tokenNames.push("MissingReturns");

        tokens.push(address(new NoRevertToken(0)));
        tokenNames.push("NoRevert");

        tokens.push(address(new PausableToken(0)));
        tokenNames.push("Pausable");

        ProxiedToken proxied = new ProxiedToken(0);
        TokenProxy proxy = new TokenProxy(address(proxied));
        tokens.push(address(proxy));
        tokenNames.push("Proxied");

        tokens.push(address(new ReentrantToken(0)));
        tokenNames.push("Reentrant");

        tokens.push(address(new ReturnsFalseToken(0)));
        tokenNames.push("ReturnsFalse");

        tokens.push(address(new RevertToZeroToken(0)));
        tokenNames.push("RevertToZero");

        tokens.push(address(new RevertZeroToken(0)));
        tokenNames.push("RevertZero");

        tokens.push(address(new TransferFeeToken(0, 0.001 ether)));
        tokenNames.push("TransferFee");

        tokens.push(address(new TransferFromSelfToken(0)));
        tokenNames.push("TransferFromSelf");

        tokens.push(address(new Uint96ERC20(0)));
        tokenNames.push("Uint96");

        tokens.push(address(new Upgradable(1)));
        tokenNames.push("Upgradable");

        uint256 i;
        for (i; i < tokenNames.length;) {
            tokenNameStr = string.concat(tokenNameStr, tokenNames[i]);
            tokenNameStr = string.concat(tokenNameStr, ",");
            unchecked {
                ++i;
            }
        }
    }

    modifier usesERC20TokenTester() {
        // short circuit if TOKEN_TEST is not enabled
        bool enabled = vm.envBool("TOKEN_TEST");
        if (!enabled) {
            // default to BaseERC20
            tokenTest = IERC20(address(tokens[0]));
            _;
            return;
        }

        // the ffi script will set `FORGE_TOKEN_TESTER_ID=n`
        uint256 envTokenId;

        try vm.envUint("FORGE_TOKEN_TESTER_ID") {
            envTokenId = vm.envUint("FORGE_TOKEN_TESTER_ID");
        } catch {}

        if (envTokenId != 0) {
            tokenTest = IERC20(tokens[envTokenId - 1]);

            // Run the user's defined assertions against our cursed ERC20
            _;
        } else {
            bytes32 a;
            assembly {
                a := calldataload(0x0)
            }
            // formatted: 0x724e4a0000000000000000000000000000
            string memory functionSelector = Strings.toHexString(uint256(a));
            string memory tokensLength = Strings.toHexString(uint256(tokens.length));

            // devMode = false means we should call the script from `lib/token-tester/script.sh`
            // devMode = true means we should call the script from the root repo `script.sh`
            bool devMode;
            string memory scriptInvokation = "lib/token-tester/script.sh";
            try vm.envBool("TOKEN_TEST_DEV_MODE") {
                devMode = vm.envBool("TOKEN_TEST_DEV_MODE");
                if (devMode) {
                    scriptInvokation = "script.sh";
                }
            } catch {}

            string[] memory _ffi = new string[](5);
            _ffi[0] = "sh";
            _ffi[1] = scriptInvokation;
            _ffi[2] = functionSelector;
            _ffi[3] = tokensLength;
            _ffi[4] = tokenNameStr;

            // Runs many `FORGE_TOKEN_TESTER_ID=n forge test --mt function_name` in parallel
            vm.ffi(_ffi);
        }
    }

    modifier usesTokenTester() {
        uint256 i;
        for (i; i < tokens.length;) {
            tokenTest = IERC20(tokens[i]);
            _;
            unchecked {
                ++i;
            }
        }
    }

    modifier usesSingleToken(uint256 index) {
        vm.assume(index < tokens.length);
        tokenTest = IERC20(tokens[index]);
        _;
    }
}
