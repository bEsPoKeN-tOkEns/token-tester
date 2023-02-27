// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.8.0;

import {ERC20} from "solmate/tokens/ERC20.sol";
import {MockERC20} from "solmate/test/utils/mocks/MockERC20.sol";

contract BaseERC20 is MockERC20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) MockERC20(_name, _symbol, _decimals) {}
}
