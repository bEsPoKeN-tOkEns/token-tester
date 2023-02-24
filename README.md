# Token Tester
Developing and implementing composability with various tokens in blockchain applications can be a daunting and unnerving task, particularly in the DeFi space where security is a priority and the stakes are high. Token Tester is a tool designed to help developers ensure that their protocol contract logic is safe and secure when acting on various token implementations. Bridging the gap between perfect standards, imperfect implementations, and straight-up malicious tokens, Token Tester provides an ergonomic test suite of "bespoken tokens" that developers can use to test their protocol's contract logic.


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



## How Token Tester Works
Token Tester is powered by Foundry, and comes packaged in a git submodule that can be installed directly into a Foundry project. A `TokenTester` contract is provided and is designed to be inherited by any testing contract, similar to common tools like `forge-std/Test` and `forge-std/Script`. 

Incorporating the logic into tests requires adding a modifier to an existing testing function, and using an inherited variable named `testToken` as the token. From here, Token Tester handles the rest, including deploying the bespoken tokens, running the test and tracking results.

Results are outputted in HTML format, making them easy to understand and share with others.

## Get Started with Token Tester
Within your Foundry project:

```
forge install bespoken-tokens/token-tester

TOKEN_TEST=true; forge test --ffi

# view token-tester.html in your browser
```