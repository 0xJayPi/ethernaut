## 0.Hello Ethernaut

```Contract instance: 0xdBF90CF9aC26b2E2737ED1305eff9CE6e65D7e23```

### Steps
1. For this level, I used the web console first
```javascript
await contract.info()
'You will find what you need in info1().'
await contract.info1()
'Try info2(), but with "hello" as a parameter.'
await contract.info2("hello")
'The property infoNum holds the number of the next info method to call.'
await contract.infoNum()
i {negative: 0, words: Array(2), length: 1, red: null}length: 1negative: 0red: nullwords: Array(2)0: 42length: 2[[Prototype]]: Array(0)[[Prototype]]: Object
await contract.info42()
'theMethodName is the name of the next method.'
await contract.theMethodName()
'The method name is method7123949.'
await contract.method7123949()
'If you know the password, submit it to authenticate().'
await contract.password()
'ethernaut0'
```

2. Then, I forked sepolia and tested the password using ```forge test -C test/Level0.exp.sol```
3. Finally, after confirming the level got cleared in the fork, I used the password in sepolia to clear the level ```forge script script/Level0.script.sol --private-key [PRIVATE_KEY] --broadcast --rpc-url https://rpc.ankr.com/eth_sepolia```