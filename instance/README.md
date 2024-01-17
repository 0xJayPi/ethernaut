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

Local environment: `forge test --mc ExploitLevel00` || 
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

Local environment: `forge test --mc ExploitLevel01` || 
Sepolia: `forge script script/Level01.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 02.Fallout

`Ethernaut Instance: 0x8216C602F2A89ec5C915C21C82Cb8E2359fBF033`

### Steps
In older versions of solidity, you would name the constructor with the same name as the contract. In this case, there's a typo in the function. Hence, it can be called by anyone at any time. Though, as silly as it sounds, this was a real attack when DynamicPyramid renamed their protocol to Rubixi
1- I only need to call `Fal1out()` to claim ownerhsip of the contract

### Running the code

Local environment: `forge test --mc ExploitLevel02` || 
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

Local environment: `forge test --mc ExploitLevel03` || 
Sepolia: `forge script script/Level03.exp.sol:ExploitLevel03 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 04.Telephone

`Ethernaut Instance: 0x5B3BBBB08afA2fD125D0dB3c7c455909D11E5F43`

### Steps
It's fundamental to understand the difference between `tx.origin` and `msg.sender`. The former is always the EOA that iniciated the transaction whereas the latter is the source of the last call. To crack this level, I need to use an intermediary contract to bypass the validation in `changeOwner()` so that the `msg.sender` is not my EOA.
1. I created an `Intermediary` contract in my test file to use it to call the instance.
2. When the validation in `changeOwner()` is triggered, `msg.sender == address(Intermediary)` and `tx.origin == msg.sender`. Thus, I'm now able to send `msg.sender` as parameter and change the owner.

### Running the code

Local environment: `forge test --mc ExploitLevel04` || 
Sepolia: `forge script script/Level04.exp.sol:ExploitLevel04 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 05.Token

`Ethernaut Instance: 0x21d06aC321053C031aefd719D08f86A3aaf7723d`

### Steps
Before Solidity 8.0.0, mathematical operations could overflow/underflow resulting in unexpected behaviours if not considered within the contract logic. It was the accepted approach to implement OpenZeppelin's SafeMath library to prevent it from happening. From Solidity 8.0.0 onwards, any overflow/underflow triggers a panic resulting in a revert
1. I set the local environment to validate the underflow I want to trigger for `balances[]`. The objective is to set its value to what-would-be `-1`, which, as a consequence of the underflow, will actually result in `type(uint256).max`
2. By sending 21 tokens (any value > 20 tokens) from the player address to any address, I triggered the underflow in `balances[player]`

### Running the code

Local environment: `forge test --mc ExploitLevel05` || 
Sepolia: `forge script script/Level05.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 06.Delegation

`Ethernaut Instance: 0x298e1F2cf32a2635C24699821D48c42Ad2d53456`

### Steps
`delegatecall()` executes the logic of the callee contract in the context of the caller one. Thus, I need to do a `delegatecall()` from the `Delegation` (instance) contract to the `Delegate` (logic) contract so that the the `owner` var is updated to `msg.sender` in the context of the `Delegation`. It's key to remember that there's no association between the names of the variables of the contracts but the storage slot they occupy. In this case `owner` uses slot0 of both contracts.
1. In my local test, I first encode the signature of the function `pwn()` to send it in the call.
2. Then, I call the instance with the signature of `pwn()`, which doesn't match any function in the contract and thus, triggers the `fallback()` one. As a consequence the msg.data is forward to the `Delegate` contract, which does have a matching function.

### Running the code

Local environment: `forge test --mc ExploitLevel06` || 
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

Local environment: `forge test --mc ExploitLevel07` || 
Sepolia: `forge script script/Level07.exp.sol:ExploitLevel07 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 08.Vault

`Ethernaut Instance: 0x64f630b9B9035B21413fB85C0CAB5ADd53049587`

### Steps
It's import to remember that setting `private` to variables only prevent them from being read by other contracts. It does NOT mean that their private and can't be read by anybody. Likewise, no data on-chain is private, including storage and transactions data.
1. My first objective is to read the password from the instance storage. I know it's located in slot 1 because of being a 32 bytes variable and storage layout rules of Solidity. To read storage of contracts I can use the `cast` commnand. `cast storage 0x64f630b9B9035B21413fB85C0CAB5ADd53049587 1 --rpc-url $SEPOLIA`
2. Once I have the password to unlock the contract, I only need to call the `unlock()` function.

### Running the code

Local environment: `forge test --mc ExploitLevel08 --rpc-url $SEPOLIA` || 
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

Local environment: `forge test --mc ExploitLevel09 --rpc-url $SEPOLIA` || 
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

Local environment: `forge test --mc ExploitLevel10` || 
Sepolia: `forge script script/Level10.exp.sol:ExploitLevel10 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 11.Elevator

`Ethernaut Instance: 0x2DfA43D2504786BD3DB86c9dFBDcbC12Fb802D4F`

### Steps
Here I need to differentiate between calls to `msg.sender`, meaning that if it's the first call I'll reply `false` and then, when the second call comes I'll reply `true`.
1. I need to have a contract which is the actual caller of `Elevator`.
2. This contract needs to have the function in the interface `function isLastFloor(uint256) external returns (bool)` so that it can be called by the `Elevator`.
3. And within the `isLastFloor()` function in the attacking contract I set a bool to differentiate whether the contract was already called or not. 

### Running the code

Local environment: `forge test --mc ExploitLevel11` || 
Sepolia: `forge script script/Level11.exp.sol:ExploitLevel11 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 12.Privacy

`Ethernaut Instance: 0x762db17A37E974b80ed9b5Ccc1c57c6Ca8eF3B40`

### Steps
The same as in level 08.Vault applies for this case, no data on-chain is private. The challenge for this case reside on properly understanding the storage layout of the EVM:
```solidity
bool public locked = true; // slot 0
uint256 public ID = block.timestamp; // slot 1
uint8 private flattening = 10; // slot 2
uint8 private denomination = 255; // slot 2
uint16 private awkwardness = uint16(block.timestamp); // slot 2
bytes32[3] private data; // slot 3 to 6
```
To undesrtand what we're looking for, I check the require in the `unlock()` function: `require(_key == bytes16(data[2]));`. Thus, the key is found in the `bytes32[2]` variable, i.e. `slot 5`.
1. I use `cast` to read the storage of the instance: `cast storage 0x762db17A37E974b80ed9b5Ccc1c57c6Ca8eF3B40 5 --rpc-url $SEPOLIA`
2. Now that I have the value of `slot 5`, I cast it into 16 bytes, since this is the parameter type of the `unlock()` function.
3. And call `unlock()`

### Running the code

Local environment: `forge test --mc ExploitLevel12` || 
Sepolia: `forge script script/Level12.exp.sol:ExploitLevel12 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 13.GatekeeperOne

`Ethernaut Instance: 0x7CF153d2D53843c52A81d7366491dc1bdB2a118e`

### Steps
I'll plan my attack gate by gate so that I crack one challenge at the time.
#### _GateOne_
To make `msg.sender != tx.origin` I need to use a contract that will perform the calls to the instance.

#### _GateTwo_
I chose to tackle this gate by brute force. 
1. Within my contract, I create a foor loop.
2. And do a `call` to the instance function `enter()` to find the value of `i`, `address(instance).call{gas: i + (8191 * 3)}(abi.encodeWithSignature("enter(bytes8)", _gateKey));`. To be clear, I do a `call`, insteand of calling `enter()` at once, to avoid the tx from reverting.
3. In the script I used on-chain, I divided the process in two, just for the sake of gas consumptiom. So `attackSim()` is not broadcasted and used to find the value of `i`, which I then send to `attackReal()` that is broadcasted.

#### _GateThree_
In solidity I can apply a "mask" to the input with the "AND" operator. 
1. Let's start with the first require: `uint32(uint64(_gateKey)) == uint16(uint64(_gateKey))`. The right-most 2 bytes must equal the right-most 4 bytes. It means that I want to "remove" the 2 left-most bytes of those 4 bytes but maintain the value of the right-most one. Because what I want is to make 0x11111111 be equal to 0x00001111. The mask to accomplish this is equal to `0x0000FFFF`.
3. Then, I move to the second require: `uint32(uint64(_gateKey)) != uint64(_gateKey)`. The right-most 8 bytes of the input must be different compared to the right-most 4 bytes. I need to remember that I also need to maintain the first requirement. So I need to make 0x00000000001111 be != 0xXXXXXXXX00001111. I need to update our mask to make all the first 4 bytes "pass" to the output. The new mask will be `0xFFFFFFFF0000FFF`
4. Now, the third require: `uint64(_gateKey)) == uint16(uint160(tx.origin)`. I  need to apply the mask to `tx.origin` casted to a bytes8 to pass the this condition, `bytes8(uint64(uint160(tx.origin))) & 0xFFFFFFFF0000FFFF`

### Running the code

Local environment: `forge test --mc ExploitLevel13` || 
Sepolia: `forge script script/Level13.exp.sol:ExploitLevel13 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 14.GatekeeperOne

`Ethernaut Instance: 0xEADfE8A7437e3fb7ce09035f4bce521D29fDbd5C`

### Steps
I'll plan my attack gate by gate so that I crack one challenge at the time.
#### _GateOne_
To make `msg.sender != tx.origin` I need to use a contract that will perform the calls to the instance.

#### _GateTwo_
Here, the require is looking for the `msg.sender` to not have code, `extcodesize(caller()`. Considering that I need to use another contract to unlock _GateOne_, I have to use a workaround to make the call from a contract which actually have no code in it. 
1. At the moment of creation, there's yet no code in the contract on-chain. So I have to execute all the code within the `constructor()`

#### _GateThree_
Taking into account how XOR Gates work, if I do a XOR of the result with one of the variables, I obtain the other variable.
1. I have to do a little of reverse engineering to obtain the `gateKey`, `bytes8 gateKey = bytes8(uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^ type(uint64).max);`

### Running the code

Local environment: `forge test --mc ExploitLevel14` || 
Sepolia: `forge script script/Level14.exp.sol:ExploitLevel14 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 15.NaughtCoin

`Ethernaut Instance: 0x46a0b1BA3425e277c27851a6E575bBB0669eE21b`

### Steps
Here the `NaughCoin` contract is not considering all the functions that it's inheriting from `ERC20.sol`. In this case, I can exploit `transferFrom()`.
1. I use a contract to transfer my coins to it, named `AttackNaughtCoin`.
2. Next, I call `approve()` with my total balance as `amount` and the addres of the attack contract as `to`.
3. Finally, I make the attack contract transfer of my balance to itself using the `transfer()` function in `AttackNaughtCoin`.

### Running the code

Local environment: `forge test --mc ExploitLevel15` || 
Sepolia: `forge script script/Level15.exp.sol:ExploitLevel15 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 16.Preservation

`Ethernaut Instance: 0x9dc2DC6421704EB1161c7c5917C1CDdd0f5854B9`

### Steps
When a `delegatecall()` is done, the code of `callee` is executed in the context of the `caller`. Hence, `LibraryContract.setTime()` is not actually updating the storage of `LibraryContract` but the storage of `Preservation` instead.
1. I need to replace one of the `timeZoneLibrary` address with a contract address I control in order to update the storage of `Preservation`.
2. So I created a contract `AttackPreservation` and used its address to replace the `timeZone1Library` one.
To consider, when calling `Preservation.setFirstTime()`, this function is not actually updating `LibraryContract.storedTime` as it first look like. The call updates `Preservation.timeZone1Library` because what it was mentioned before
3. Now, I casted the address of `AttackPreservation` in a uint256 to pass it as parameter of `Preservation.setFirstTime(uint)`. See `uint256(uint160(address(attackP)))`
4. At this point, I had already replaced the address of `timeZone1Library` with the address of `AttackPreservation`. Then, I called `Preservation.setFirstTime()` which is now calling `AttackPreservation.setTime` and changing the value of `Preservation.owner` to the address I chose.

### Running the code

Local environment: `forge test --mc ExploitLevel16` || 
Sepolia: `forge script script/Level16.exp.sol:ExploitLevel16 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 17.Recovery 

`Ethernaut Instance: 0xCaB3f916ee9686a5212eE054064Abe656Fc5c6fD`

### Steps
Though I don't have the address of the token created, I do have the address of the contract factory for the level, `0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048`. So, I can go into https://sepolia.etherscan.io/ and review the transactions to identify the one that created the instance, which is `0xa0ff1caed0bd962641095cea821de07bd29af58fbbf723d16ba47439d18055ed`. Then, digging into the transaction, I can see the addres of the token missed, `0x385321Bc1037590fb1EE572e0EbE933021140424`, and the address of the creator, `0xAF98ab8F2e2B24F42C661ed023237f5B7acAB048`.
1. Now, with the information previously collected, I called the `destroy()` function in the token instance.

### Running the code

Local environment: `forge test --mc ExploitLevel16` || 
Sepolia: `forge script script/Level16.exp.sol:ExploitLevel16 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 18.Magic Number

`Ethernaut Instance: 0x9997d552B662f666372EA436F4D6086652cd3474`

### Steps
To unlock this level, I have to use the evm opcodes in order to build the binary of the contract. Then, I create the contract using the opcode `CREATE` and store the address in `instance.solver`.
1. The `runtime bytecode` will retrieve the value `42` in hex, `2a`. So, first I need to store this value so then I can return it:

```solidity
0x602a  = PUSH(0x2a) => push 2a into the stack
0x6080  = PUSH(0x80) => push a random memory slot (80)
0x52    = MSTORE => store value p=0x2a at position v=0x80
0x6020  = PUSH(0x20) =>  size of value is 32 bytes
0x6080  = PUSH(0x80) =>  position in slot 0x80
0xf3    = RETURN => return value at p=0x80 slot and of size s=0x20

```
`Runtime Bytecode: 602a60805260206080f3`

2. Now, I have to build the `initialization bytecode` that will duplicate the `runtime bytecode` so then it's returned to the EVM:

```solidity
0x600a  = PUSH(0x0a) => `s=0x0a` or 10 bytes
0x600c  = PUSH(0x0c) => position of the runtime code, 0x (12 in decimals)
0x6000  = PUSH(0x00) => `t=0x00` - arbitrary chosen memory location
0x39    = CODECOPY => calling the CODECOPY with all the arguments
0x600a  = PUSH(0x0a) => size of opcode is 10 bytes
0x6000  = PUSH(0x00) => value was stored in slot 0x00
0xf3    = RETURN => return value at p=0x00 slot and of size s=0x0a
```
`Initiation Bytecode: 600a600c600039600a6000f3`

`Final Bytecode: 600a600c600039600a6000f3602a60505260206050f3 (Initation Bytecode + Runtime Bytecode)`

3. Finally, I have to use the `Final Bytecode` to create the contract and pass the address to the `Ethernaut Instance`.

### Running the code

Sepolia: `forge script script/Level18.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 19.Alien Codex

`Ethernaut Instance: 0x052b8cbFd3c459DCFAB4E53ef8a56062Ac0aBf77`

### Steps
Though there's no function to modify the owner in the ABI, I can still play around with the dynamic array `codex`. Likewise, being Solidity 0.5.0, I can also overflow/underflow uints/ints. Having this in maind, I took a look at the storage layout of the contract
```solidity
address owner; // slot 0
bool public contact; // slot 0
bytes32[] public codex; // slot 1: codex.length and slot keccak256(abi.encode(1)): codex[0]
```
So, My objective now is to reach slot 0 using the index of `codex` and overwrite it with my address. Though I'll also overwrite `contact`, I won't need it any more at this point.
1. I have to resolve the index that will match slot 0 => `index = ((2 ** 256) - 1) - uint256(keccak256(abi.encode(1))) + 1`
2. I call `instance.makeContact()` to be able to interact with the contract.
3. I now call `instance.retract()` to underflow the index of the `codex[]`.
4. Now I cast my address in bytes 32 => `bytes32 player = bytes32(uint256(uint160(0x9606e11178a83C364108e99fFFD2f7F75C99d801)))`
5. And finally, I call `instance.revise(index, player)`

### Running the code

Sepolia: `forge script script/Level19.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 20.Denial

`Ethernaut Instance: 0xa1D42DA2040f7047721b77773f875832204DfbBA`

### Steps
I need to take advantage of managing the address that `withdraw()`. By using `call()` all the remaining gas is forwarded with the transaction, if no limit is set. Hence, I can consume all the remaining gas to make `withdraw()` always fail.
1. I create a contract and add the `receive()` function to be triggered by the instance `call()`.
2. There are a few mechanisms to consume gas, but I chose to use an infinite while loop.
3. Now, every time that `withdraw()` is called, I'll consume all the gas and cause a DoS.

### Running the code

Sepolia: `forge script script/Level20.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 21.Shop

`Ethernaut Instance: 0x6D54C806384AF05Ca8338B8E8153D51886BBB46D`

### Steps
The attack vector in this level resides on the `buy()` making 2 calls to `Buyer` instance. So, I can return 2 different answers.
1. I create a contract and add the function `price()` to it.
2. Now, I have to add a check to differentiate the 1st from the 2nd call.
3. Finally, I return two different values to match the conditions of the `if()` and set the price I want.

### Running the code

Local environment: `forge test --mc ExploitLevel21` || 
Sepolia: `forge script script/Level21.exp.sol:ExploitLevel21 --broadcast --rpc-url $SEPOLIA`

---------------------------------

## 22.Dex

`Ethernaut Instance: 0x4B11d4B0591CEd555E7fd68DF3527614D23076C1`

### Steps
The vulnerability is located in the `getSwapPrice()` function since it's calculating the `swapAmount` not considering that Solidity has no floating point variables. Thus, on each operation I'll receive more tokens because of precission lost. I did the calculation and tested the results locally first.
```
/**
 * Calculations
 *     Dex Token1: 100, Token2: 100 || Player Token1:  10, Token2:  10 || swap: 10 token1
 *     Dex Token1: 110, Token2:  90 || Player Token1:   0, Token2:  20 || swap: 20 token2
 *     Dex Token1:  86, Token2: 110 || Player Token1:  24, Token2:   0 || swap: 24 token1
 *     Dex Token1: 110, Token2:  80 || Player Token1:   0, Token2:  30 || swap: 30 token2
 *     Dex Token1:  69, Token2: 110 || Player Token1:  41, Token2:   0 || swap: 41 token1
 *     Dex Token1: 110, Token2:  45 || Player Token1:   0, Token2:  65 || swap: 45 token2
 *     Dex Token1:   0, Token2:  90 || Player Token1: 110, Token2:  20
 */
 ```
1. Now that the math is done, I only need to swap these amounts until completely draining one of the tokens.

### Running the code

Local environment: `forge test --mc ExploitLevel22` || 
Sepolia: `forge script script/Level22.exp.sol --broadcast --rpc-url $SEPOLIA`

---------------------------------
