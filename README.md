## Ethernaut Exploits

I'll use this repo to track my approach to hack each level of [The Ethernaut](https://ethernaut.openzeppelin.com/)

Folders Structure:
- instance: level files from the contract instances
- test: test of the exploit locally
- script: exploit for each level in the actual chain
- broadcast: transactions record in sepolia

Wallet Used: `Sepolia: 0x9606e11178a83C364108e99fFFD2f7F75C99d801` a.k.a. [0xJayPi.eth](https://app.ens.domains/0xjaypi.eth)

## Levels
[Walkthrough of each level](https://github.com/0xJayPi/ethernaut/blob/main/instance/README.md)
- [x] 00.Hello Ethernaut
- [x] 01.Fallback
- [x] 02.Fallout
- [x] 03.CoinFlip
- [x] 04.Telephone
- [x] 05.Token
- [x] 06.Delegation
- [x] 07.Force
- [x] 08.Vault
- [x] 09.King
- [x] 10.Reentrance
- [x] 11.Elevator
- [x] 12.Privacy
- [x] 13.GatekeeperOne
- [x] 14.GatekeeperTwo
- [x] 15.NaughtCoin
- [x] 16.Preservation 
- [x] 17.Recovery
- [x] 18.Magic Number
- [x] 19.Alien Codex
- [x] 20.Denial
- [x] 21.Shop
- [x] 22.Dex
- [x] 23.Dex Two
- [x] 24.Puzzle Wallet
- [x] 25.Motorbike

## Testing 
- To test the code locallly: `forge test --mc ExploitLevel#`
- To run the code in sepolia: `forge script script/Level#.exp.sol:ExploitLevel# --broadcast --rpc-url $SEPOLIA`

