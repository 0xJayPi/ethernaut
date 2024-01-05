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
2. Then, I called authenticate() with the password.


## 1.Fallback

```Contract instance: 0x890CD86886Ff5eDB815aF03cb040D86A36fB5A75```

### Steps
The objective is to trigger receive() without reverting. To this end, I need to pass the require in the function. Meaning
- sendindg at least 1 wei -> ```msg.value > 0```
- having already contributed at least 1 wei -> ```contributions[msg.sender] > 0```
1. I call contribution() sending ```< 0.001 ether```
2. Now, I call receive() sending ```> 0 wei```
3. Finally, I call withdraw() to retrive all the balance now that I'm the ```owner```
