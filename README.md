## Ethernaut Exploits

I'll use this repo to track my approach to hack each level of The Ethernaut

Folders Structure:
- instance: levels files from the contract instances
- test: exploit for each level in a forked chain
- script: exploit for each level in the actual chain
- broadcast: transactions record in sepolia

Wallet Used: ```Sepolia: 0x9606e11178a83C364108e99fFFD2f7F75C99d801``` a.k.a. [0xJayPi.eth](https://app.ens.domains/0xjaypi.eth)

## Levels
[Walkthrough of each level](https://github.com/0xJayPi/ethernaut/blob/main/instance/README.md)
- [x] 0.Hello Ethernaut
- [x] 1.Fallback
- [x] 2.Fallout
- [x] 3.CoinFlip

## Testing 
- To test the code in a local fork: ```forge test -C test/Level#.test.sol```
- To run the code in sepolia ```forge script script/Level#.exp.sol --private-key $PRIVATE_KEY --broadcast --rpc-url $SEPOLIA_RPC```

