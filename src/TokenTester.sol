// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {WETH} from "solmate/tokens/WETH.sol";
import {MockERC20} from "./tokens/MockERC20.sol";
import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";
import {Strings} from "openzeppelin-contracts/contracts/utils/Strings.sol";

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
    IERC20 public tokenTest;

    address[] public tokens;
    string[] public tokenNames;

    constructor() {
        tokens.push(address(new MockERC20("Test", "TST", 18)));
        tokenNames.push("MockERC20");
        tokens.push(address(new WETH()));
        tokens.push(address(new ApprovalRaceToken(0)));
        tokens.push(address(new ApprovalToZeroToken(0)));
        tokens.push(address(new BlockableToken(0)));
        tokens.push(address(new Bytes32Metadata(0)));
        tokens.push(address(new DaiPermit(0)));
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
        tokens.push(address(new Upgradable(1)));
    }

    modifier usesTT() {
        // the ffi script will set `FORGE_TOKEN_TESTER_ID=n`
        uint envTokenId;

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

            string[] memory _ffi = new string[](4);
            _ffi[0] = "sh";
            _ffi[1] = "script.sh";
            _ffi[2] = functionSelector;
            _ffi[3] = tokensLength;

            // Runs many `FORGE_TOKEN_TESTER_ID=n forge test --mt function_name` in parallel
            bytes memory ffi_result = vm.ffi(_ffi);

            assembly {
                for { let i := 0 } lt(i, sload(tokens.slot)) { i := add(i, 2) } {
                    let first_byte := byte(0, mload(add(ffi_result, add(0x20, i))))
                    if iszero(eq(first_byte, 0x0)) {
                        let token_name := mload(add(tokenNames.slot, add(0x20, i)))
                        let token_address := mload(add(tokens.slot, add(0x20, i)))
                        let success := mload(add(0x20, first_byte))
                        if eq(success, 0x30) {
                            // token failed
                        } 
                        if eq(success, 0x31) {
                            // token passed
                            
                        }
                    }
                }
            }


            // bash script where function selector is converted to function string for `--mt`
            // i.e. testtoken.sh:
            // function_name = $( grep -r "724e4a00" out | grep "test" | cut -d: -f2 | cut -d\" -f2 | cut -d\( -f1 )
            // FORGE_TOKEN_ID=1 forge test --mt $function_name
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
