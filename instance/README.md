## 0.Hello Ethernaut

`Contract instance: 0xdBF90CF9aC26b2E2737ED1305eff9CE6e65D7e23`

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
2. Then, I called authenticate() with the password.


## 1.Fallback

`Contract instance: 0x890CD86886Ff5eDB815aF03cb040D86A36fB5A75`

### Steps
The objective is to trigger receive() without reverting. To this end, I need to pass the require in the function. Meaning
- sendindg at least 1 wei -> `msg.value > 0`
- having already contributed at least 1 wei -> `contributions[msg.sender] > 0`
1. I call contribution() sending `< 0.001 ether`
2. Now, I call receive() sending `> 0 wei`
3. Finally, I call withdraw() to retrive all the balance now that I'm the `owner`

## 2.Fallout

`Contract instance: 0x8216C602F2A89ec5C915C21C82Cb8E2359fBF033`

### Steps
In older versions of solidity, you would name the constructor with the same name as the contract. In this case, there's a typo in the function. Hence, it can be called by anyone at any time. Though, as silly as it sounds, this was a real attack when DynamicPyramid renamed their protocol to Rubixi
1- I only need to call `Fal1out()`x to claim ownerhsip of the contract

## 3.CoinFlip

`Contract instance: 0xEF4e4992db2A141d4a15CB284aA32E616d7FE5C6`

### Steps
On chain randonmess is not possible as of today, because information on-chain is public and accessible to everyone. Thus, any given user can do the same math and call the `flip()` function to guess the side of the coin.
1. I tested the solution locally to validate my assumptions.
When it comes to exploiting the contract on-chain, this time the script needs to be properly modified from the test code used before
2. In order to execute the math on-chain in an ATOMIC process, I needed to create a contract named `Player`
3. I wrote the code of the exploit in the constructor (I could have deployed a contract separately and do the exploid in a function)
4. Now, I only have to call the script 10 times to resolve the challenge

## 4.Telephone

`Contract instance: 0x5B3BBBB08afA2fD125D0dB3c7c455909D11E5F43`

### Steps
It's fundamental to understand the difference between `tx.origin` and `msg.sender`. The former is always the EOA that iniciated the transaction whereas the latter is the source of the last call. To crack this level, I need to use an intermediary contract to bypass the validation in `changeOwner()` so that the `msg.sender` is not my EOA.
1. I created an `Intermediary` contract in my test file to use it to call the instance.
2. When the validation in `changeOwner()` is triggered, `msg.sender == address(Intermediary)` and `tx.origin == msg.sender`. Thus, I'm now able to send `msg.sender` as parameter and change the owner.
3. I tested the solution locally to validate my assumptions. Then, coded a script to execute it on-chain

## 5.Token

`Contract instance: 0x21d06aC321053C031aefd719D08f86A3aaf7723d`

### Steps
Before Solidity 8.0.0, mathematical operations could overflow/underflow resulting in unexpected behaviours if not considered within the contract logic. It was the accepted approach to implement OpenZeppelin's SafeMath library to prevent it from happening. From Solidity 8.0.0 onwards, any overflow/underflow triggers a panic resulting in a revert
1. I set the local environment to validate the underflow I want to trigger for `balances[]`. The objective is to set its value to what-would-be `-1`, which, as a consequence of the underflow, will actually be `type(uint256).max`
2. After testing locally, I wrote the script to perform the transaction on-chain
3. By sending 21 tokens (any value > 20 tokens transfered to the player) from the player address to any address, I triggered the underflow in `balances[player]`

## 6.Delegation

`Contract instance: 0x298e1F2cf32a2635C24699821D48c42Ad2d53456`

### Steps
`delegatecall()` executes the logic of the callee contract in the context of the caller one. Thus, I need to do a `delegatecall()` from the `Delegation` (instance) contract to the `Delegate` (logic) contract so that the the `owner` var is updated to `msg.sender` in the context of the `Delegation`. It's key to remember that there's no association between the names of the variables of the contracts but the storage slot they occupy. In this case `owner` uses slot0 of both contracts.
1. In my local test, I first encode the signature of the function `pwn()` to send then send it in the call.
2. Once I proved the exploit works locally, I proceed to execute the exploit on-chain.

