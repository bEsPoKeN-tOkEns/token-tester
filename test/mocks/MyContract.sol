// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {MockERC4626} from "solmate/test/utils/mocks/MockERC4626.sol";

contract MyContract is MockERC4626 {
    constructor(ERC20 token) MockERC4626(token, "Mock Vault", "MV-TT") {}
}
