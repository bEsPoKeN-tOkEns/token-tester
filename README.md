# Token Tester

:sparkles: *Automagically test a variety of tokens against your Solidity smart contracts* :sparkles:

---

Developing and implementing composability with various tokens in blockchain applications can be a daunting and an unnerving task, particularly in the DeFi space where security is a priority and the stakes are high. Token Tester is a tool designed to help developers ensure that their protocol contract logic is safe and secure when acting on various token implementations. Bridging the gap between perfect standards, imperfect implementations, and straight-up malicious tokens, Token Tester provides an ergonomic test suite of "bespoken tokens" that developers can use to test their protocol's contract logic.


## The Problem
Developers face numerous challenges when implementing tokens, including issues with interoperability, security, and dealing with miscompliance according to popular standards. Hundreds[1] of[2] thousands[3] of[4] dollars[5]  in audits and bug bounties have been paid out for logical errors regarding token integrations. ERC standards are a growing list, now comprised of ERC20, ERC721, ERC777, and ERC4626 with more standards pending. Token Tester addresses these challenges by providing a suite of "bespoken tokens" that encompass this range and more, including tokens with fee-on-transfer logic, tokens with re-entrancy vulnerabilities, and tokens with malicious implementations.

Our full catalog of tokens can be found here:
- weird-erc20
- ...
- ...


TODO: cite code4rena and immunefi reports. Rari vault re-entrancy with cETH was 1 million
TODO: add more to catalog?
## Use Cases
Token Tester can be used in a variety of scenarios, including:

- Whitelist lending tokens: Understand how your protocol may behave when choosing to whitelist a new token standard as supported collateral.

- Deposit accounting: Check that tokens sporting fee-on-transfer logic are accounted for correctly when users deposit into your protocol.

- Vault reward emissions: Safely distribute rewards to users through vault emissions and be confident your re-entrancy guards work as expected.

- Swap rebasing economics: Ensure that rebasing token economics are handled correctly in your AMM 

TODO:cite AMP rebasing swap event

## Get Started & Usage

Install *token-tester*:

```bash
forge install bespoke-tokens/token-tester
```

Decorate your test functions with the TokenTester modifier
```solidity
import "forge-std/Test.sol";
import {TokenTester} from "token-tester/TokenTester.sol";

contract ExampleTest is Test, TokenTester {
    function setUp() public {
        // initialize your contract
    }
    
    // Test drive the unit test with multiple ERC20 implementations
    // the modifier `usesERC20TokenTester` and `tokenTest` is inherited from `TokenTester.sol`
    function testDeposit() public usesERC20TokenTester {
        // deal yourself some tokens to test deposit behavior
        deal(address(tokenTest), address(this), 100);
        
        // use the provided `tokenTest` (an ERC20) against the contracts
        myContract.deposit(address(tokenTest), 100);
    }
}

```

Execute token tester against your existing Foundry unit tests
```bash
TOKEN_TEST=true; forge test --ffi

# view report.html in your browser
```

## How Token Tester Works
Token Tester is powered by Foundry, and comes packaged in a git submodule that can be installed directly into a Foundry project. A `TokenTester` contract is provided and is designed to be inherited by any testing contract, similar to common tools like `forge-std/Test` and `forge-std/Script`. 

Incorporating the logic into tests requires adding a modifier to an existing testing function, and using an inherited variable named `testToken` as the token. From here, Token Tester handles the rest, including deploying the bespoken tokens, running the test and tracking results.

Results are outputted in HTML format, making them easy to understand and share with others.
