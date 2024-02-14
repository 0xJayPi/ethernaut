
<details>
  <summary> Version Issues </summary> 

  - [ ] Solidity 0.8.13 - Use of Solidity 0.8.13 with known issues in ABI encoding and memory side effects [Reference](https://github.com/code-423n4/2022-06-putty-findings/issues/348)
  - [ ] Solidity 0.8.17 - abi.encodePacked allows hash collision in Solidity 0.8.17 [Reference](https://github.com/sherlock-audit/2022-10-nftport-judging/issues/118)
  - [ ] OpenZeppelin < 4.7.3 - OpenZeppelin has a vulnerability in versions lower than 4.7.3 [Reference](https://github.com/sherlock-audit/2022-09-harpie-judging/blob/main/010-M/010-h.md)
  - [ ] selfdestruct() - After EIP-4758, selfdestruct won't work [Reference](https://github.com/code-423n4/2022-07-axelar-findings/issues/20)
</details>

<details>
  <summary>Inheritance</summary>

  - [ ] Upgradability - Make sure to inherit the correct branch of OpenZepplin library [Reference](https://solodit.xyz/issues/912)
  - [ ] Initializable inheritance - Inheritable/Upgradable contracts should use initializer modifier carefully [Reference](https://solodit.xyz/issues/1684)
  - [ ] Interface implementation - Check if all functions are implemented from the interface [Reference](https://solodit.xyz/issues/1322)
  - [ ] Ownable - ownership transfer - Use two-step process and make sure the protocol works while transfer [Reference](https://solodit.xyz/issues/3525)
</details>

<details>
  <summary>Initialization</summary>

  - [ ] State variables initialization - Check if important variables are initialized correctly [Reference](https://solodit.xyz/issues/2594)
  - [ ] Initialization arguments validation - Check if important variables are validated on initialization [Reference](https://solodit.xyz/issues/3537)
  - [ ] Domain Separator - Check if DOMAIN_SEPARATOR is set correctly [Reference](https://solodit.xyz/issues/2507)
  - [ ] Set critical params in constructor [Reference](https://github.com/code-423n4/2022-05-backd-findings/issues/99)
</details>

<details>
  <summary>Validation</summary>

  - [ ] Min/Max validation - Check if parameters are capped correctly [Reference](https://solodit.xyz/issues/3591)
  - [ ] Time validation
  - [ ] Zero input, double call validation
  - [ ] Calling multiple times - Calling a function X times with value Y == Calling it once with value XY
  - [ ] src==dst - Check what happens if an action is done to itself
  - [ ] don't check min threshold during withdrawal - Users wouldn't withdraw dust [Reference](https://solodit.xyz/issues/5912)
  - [ ] Don't use Address.isContract() for EOA checking [Reference](https://solodit.xyz/issues/5925)
  - [ ] OnlyEOA modifier using tx.origin [Reference](https://solodit.xyz/issues/6662)
</details>

<details>
  <summary>Admin Privilege</summary>

  - [ ] Rescue tokens from contract(2 addresses token) - Shouldn't allow to withdraw user's funds
  - [ ] Change active orders - Admin can change price/fee at any time for existing orders [Reference](https://github.com/code-423n4/2022-06-putty-findings/issues/422)
</details>

<details>
  <summary>Denial Of Service (DOS)</summary>

  - [ ] Withdraw check - Follow Withdraw-Pattern for best practice [Reference](https://solodit.xyz/issues/2939)
  - [ ] External contracts interaction - Make sure the protocol is not affected when the external dependencies do not work [Reference](https://solodit.xyz/issues/2967)
  - [ ] Minimum transaction amount - Disallow zero amount transactions to prevent attackers putting enormous requests [Reference](https://solodit.xyz/issues/1516)
  - [ ] Tokens with blacklisting - USDC
  - [ ] Forcing protocol to go through a list - e.g. queue of dust withdrawals
  - [ ] Possible DOS with low decimal tokens - The process wouldn't work because token amount is 0 when it should work [Reference](https://solodit.xyz/issues/6998)
  - [ ] Check overflow during multiply [Reference](https://solodit.xyz/issues/6854)
  - [ ] Use unchecked for TickMath, FullMath from uniswap - These libraries of uniswap use version 0.7.6 [Reference](https://solodit.xyz/issues/6879)
</details>

<details>
  <summary>Gas limit</summary>

  - [ ] Active draining gas - An attacker can drain gas and leave very little to prevent future processing [Reference](https://solodit.xyz/issues/3709)
  - [ ] Long loop - Loop without start index [Reference](https://github.com/sherlock-audit/2022-11-isomorph-judging/issues/69)
</details>

<details>
  <summary>Replay Attack</summary>

  - [ ] Failed TXs are open to replay attacks [Reference](https://github.com/code-423n4/2022-03-rolla-findings/issues/45)
  - [ ] Replay signature attack on another chain [Reference](https://github.com/sherlock-audit/2022-09-harpie-judging/blob/main/004-M/004-m.md)
</details>

<details>
  <summary>Pause/Unpause</summary>

  - [ ] Users can't cancel/withdraw when paused
  - [ ] Users can't avoid to pay penalty(interest) when paused
</details>

<details>
  <summary>Re-entrancy</summary>

  - [ ] CEI pattern check [Reference](https://solodit.xyz/issues/3560)
  - [ ] Complicated path exploit [Reference](https://solodit.xyz/issues/3383)
</details>

<details>
  <summary>Front-run</summary>

  - [ ] Get or Create - This kind of work is very likely to have vulnerability to frontrunning
  - [ ] Two-transaction actions should be safe from frontrunning - A good example is when the protocol depends on the user's approval to take the token [Reference](https://github.com/sherlock-audit/2022-11-isomorph-judging/issues/47)
  - [ ] Make other's call revert by calling first with dust [Reference](https://solodit.xyz/issues/5920)
</details>

<details>
  <summary>Array</summary>

  - [ ] Transaction while reassignment - Best practice - do not require index as a parameter
  - [ ] Summing vs separate
