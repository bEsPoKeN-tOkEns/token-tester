# Token Tester

:sparkles: *Test a variety of unconventional tokens against your smart contracts* :sparkles:

"Wow, it's just a modifier? Now that's *ergonomic*" -chad dev, probably

---


## The Problem
Developers face the challenge of unknowingly interfacing with miscompliant tokens. Hundreds[1] of[2] thousands[3] of[4] dollars[5]  in audits and bug bounties have been paid out for logical errors regarding token integrations. ERC standards are a growing list, now comprised of ERC20, ERC721, ERC777, and ERC4626 with more standards pending.

Token Tester provides a suite of *bespoke tokens* that encompass this range of standards and more, including tokens with fee-on-transfer logic, tokens with re-entrancy vulnerabilities, and tokens with malicious implementations.

## Footgun tokens
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

*Decorate your test functions with the TokenTester modifier(s)*
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

Enable token tester when running Foundry unit tests:
```bash
TOKEN_TEST=true; forge test --ffi

# view report.html in your browser
```

## How Token Tester Works
Token Tester is powered by Foundry, and comes packaged in a git submodule that can be installed directly into a Foundry project. A `TokenTester` contract is provided and is designed to be inherited by any testing contract, similar to common tools like `forge-std/Test` and `forge-std/Script`. 

Incorporating the logic into tests requires adding a modifier to an existing testing function, and using an inherited variable named `testToken` as the token. From here, Token Tester handles the rest, including deploying the bespoken tokens, running the test and tracking results.

Results are outputted in HTML format, making them easy to understand and share with others.
