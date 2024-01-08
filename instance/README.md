## 00.Hello Ethernaut

`Ethernaut Instance: 0xdBF90CF9aC26b2E2737ED1305eff9CE6e65D7e23`

### Steps
Since there's no details about the contract, which is not verified in etherscan either, the first step is to look into the contract abi to undestand which functions are external and can be called.
1. For this level, I used the web console first to get the password.
```javascript
contract.abi
...
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
2. I then, tested the password locally. 
3. Finally, I called `authenticate()` with the password. 

### Running the code

Local environment: `forge test --mc ExploitLevel00`
Sepolia: `forge script script/Level00.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 01.Fallback

`Ethernaut Instance: 0x890CD86886Ff5eDB815aF03cb040D86A36fB5A75`

### Steps
The objective is to trigger `receive()` without reverting. To this end, I need to pass the require in the function. Meaning
- sendindg at least 1 wei -> `msg.value > 0`
- having already contributed at least 1 wei -> `contributions[msg.sender] > 0`
1. I call `contribution()` sending `< 0.001 ether`
2. Now, I call `receive()` sending `> 0 wei`
3. Finally, I call `withdraw()` to retrive all the balance now that I'm the `owner`

### Running the code

Local environment: `forge test --mc ExploitLevel01`
Sepolia: `forge script script/Level01.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 02.Fallout

`Ethernaut Instance: 0x8216C602F2A89ec5C915C21C82Cb8E2359fBF033`

### Steps
In older versions of solidity, you would name the constructor with the same name as the contract. In this case, there's a typo in the function. Hence, it can be called by anyone at any time. Though, as silly as it sounds, this was a real attack when DynamicPyramid renamed their protocol to Rubixi
1- I only need to call `Fal1out()` to claim ownerhsip of the contract

### Running the code

Local environment: `forge test --mc ExploitLevel02`
Sepolia: `forge script script/Level02.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 03.CoinFlip

`Ethernaut Instance: 0xEF4e4992db2A141d4a15CB284aA32E616d7FE5C6`

### Steps
On chain randonmess is not possible as of today, because information on-chain is public and accessible to everyone. Thus, any given user can do the same math and call the `flip()` function to guess the side of the coin.
1. I copied the masth of the instance and executed the same to guess the flip result.
2. In order to execute the math on-chain in an ATOMIC process, I needed to create a contract named `Player`.
3. I wrote the code of the exploit in the `constructor()`. I could have deployed a contract separately and do the exploid in a function, but gas optimization was not relevant.
4. Now, I only have to call the script 10 times to resolve the challenge.

### Running the code

Local environment: `forge test --mc ExploitLevel03`
Sepolia: `forge script script/Level03.exp.sol:ExploitLevel03 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 04.Telephone

`Ethernaut Instance: 0x5B3BBBB08afA2fD125D0dB3c7c455909D11E5F43`

### Steps
It's fundamental to understand the difference between `tx.origin` and `msg.sender`. The former is always the EOA that iniciated the transaction whereas the latter is the source of the last call. To crack this level, I need to use an intermediary contract to bypass the validation in `changeOwner()` so that the `msg.sender` is not my EOA.
1. I created an `Intermediary` contract in my test file to use it to call the instance.
2. When the validation in `changeOwner()` is triggered, `msg.sender == address(Intermediary)` and `tx.origin == msg.sender`. Thus, I'm now able to send `msg.sender` as parameter and change the owner.

### Running the code

Local environment: `forge test --mc ExploitLevel04`
Sepolia: `forge script script/Level04.exp.sol:ExploitLevel04 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 05.Token

`Ethernaut Instance: 0x21d06aC321053C031aefd719D08f86A3aaf7723d`

### Steps
Before Solidity 8.0.0, mathematical operations could overflow/underflow resulting in unexpected behaviours if not considered within the contract logic. It was the accepted approach to implement OpenZeppelin's SafeMath library to prevent it from happening. From Solidity 8.0.0 onwards, any overflow/underflow triggers a panic resulting in a revert
1. I set the local environment to validate the underflow I want to trigger for `balances[]`. The objective is to set its value to what-would-be `-1`, which, as a consequence of the underflow, will actually result in `type(uint256).max`
2. By sending 21 tokens (any value > 20 tokens) from the player address to any address, I triggered the underflow in `balances[player]`

### Running the code

Local environment: `forge test --mc ExploitLevel05`
Sepolia: `forge script script/Level05.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 06.Delegation

`Ethernaut Instance: 0x298e1F2cf32a2635C24699821D48c42Ad2d53456`

### Steps
`delegatecall()` executes the logic of the callee contract in the context of the caller one. Thus, I need to do a `delegatecall()` from the `Delegation` (instance) contract to the `Delegate` (logic) contract so that the the `owner` var is updated to `msg.sender` in the context of the `Delegation`. It's key to remember that there's no association between the names of the variables of the contracts but the storage slot they occupy. In this case `owner` uses slot0 of both contracts.
1. In my local test, I first encode the signature of the function `pwn()` to send it in the call.
2. Then, I call the instance with the signature of `pwn()`, which doesn't match any function in the contract and thus, triggers the `fallback()` one. As a consequence the msg.data is forward to the `Delegate` contract, which does have a matching function.

### Running the code

Local environment: `forge test --mc ExploitLevel06`
Sepolia: `forge script script/Level06.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 07.Force

`Ethernaut Instance: 0xB2275762DECB833F784eFd8639Af6464a7758bc5`

### Steps
There're a few ways to foce ETH into a contract, even if it has no payable function at all. One of them is the use of `selfdestruct()`, which takes an address as parameter and send all the balance of the contract to such address.
1. To exploit the level, I created another contract that I used to have `1 wei`.
2. In this contract, function `attack()` does a `selfdestruct()` using the instance address as parameter.
3. Now, the instance has `1 wei` of balance.

### Running the code

Local environment: `forge test --mc ExploitLevel07`
Sepolia: `forge script script/Level07.exp.sol:ExploitLevel07 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 08.Vault

`Ethernaut Instance: 0x64f630b9B9035B21413fB85C0CAB5ADd53049587`

### Steps
It's import to remember that setting `private` to variables only prevent them from being read by other contracts. It does NOT mean that their private and can't be read by anybody. Likewise, no data on-chain is private, including storage and transactions data.
1. My first objective is to read the password from the instance storage. I know it's located in slot 1 because of being a 32 bytes variable and storage layout rules of Solidity. To read storage of contracts I can use the `cast` commnand. `cast storage 0x64f630b9B9035B21413fB85C0CAB5ADd53049587 1 --rpc-url $SEPOLIA`
2. Once I have the password to unlock the contract, I only need to call the `unlock()` function.

### Running the code

Local environment: `forge test --mc ExploitLevel08 --rpc-url $SEPOLIA`
Sepolia: `forge script script/Level08.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 09.King

`Ethernaut Instance: 0x374085Fb1751CFfF55442837f1094432Ef1F6a3A`
### Steps
The vulnerability in the instance resides in the line `payable(king).transfer(msg.value);` inside the `receive()` function. If this `transfer()` fail, the transaction will revert blocking the functionality of the contract (DoS attack). I.e. every time a EOA sends a higher prize to be the king, the transaction will revert. 
1. I need to use a contract that sends a higher prize and claims the `king`. This contract must NOT have a `receive()` or `fallback()` payable function.
2. Then, I trigger this contract with a `msg.value` higher than current `prize`.
3. Whoever tries to be king afterwards will have their transaction reverted because `transfer()` will always fail

### Running the code

Local environment: `forge test --mc ExploitLevel09 --rpc-url $SEPOLIA`
Sepolia: `forge script script/Level09.exp.sol:ExploitLevel09 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 10.Reentrancy

`Ethernaut Instance: 0x05317Bce5110891Fa4c9E764C89bDDD519f5503F`

### Steps
Reentrancy attacks are one of the most exploited attack vectors in web3. The core issue relies on the contract doing an external call before updating the relevant state variables. In other words, not following CEI pattern, i.e. Checks-Effects-Iterations.
1. To hack this level, I need to use an `Attack` contract, which has a `receive()` function that will reentrant into the target contract.
2. I make sure first that the `Attack` contract has enough balance in the instance first.
3. Then, I call `instance.withdraw()` from the `Attack` contract and when the instance do the call to transfer the ETH, it triggers  `receive()` in the `Attack` contract, wich will continue calling `instance.withdraw()` until funds are drained.

### Running the code

Local environment: `forge test --mc ExploitLevel10`
Sepolia: `forge script script/Level10.exp.sol:ExploitLevel10 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 11.Elevator

`Ethernaut instance: 0x2DfA43D2504786BD3DB86c9dFBDcbC12Fb802D4F`

### Steps
Here I need to differentiate between calls to `msg.sender`, meaning that if it's the first call I'll reply `false` and then, when the second call comes I'll reply `true`.
1. I need to have a contract which is the actual caller of `Elevator`.
2. This contract needs to have the function in the interface `function isLastFloor(uint256) external returns (bool)` so that it can be called by the `Elevator`.
3. And within the `isLastFloor()` function in the attacking contract I set a bool to differentiate whether the contract was already called or not. 

### Running the code

Local environment: `forge test --mc ExploitLevel11`
Sepolia: `forge script script/Level11.exp.sol:ExploitLevel11 --broadcast --rpc-url $SEPOLIA`

---------------------------------