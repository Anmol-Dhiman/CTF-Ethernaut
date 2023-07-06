# Question Statement
You've uncovered an Alien contract. Claim ownership to complete the level.

  Things that might help

    Understanding how array storage works
    Understanding ABI specifications
    Using a very underhanded approach


- Reference ->
https://ethernaut.openzeppelin.com/level/0x0BC04aa6aaC163A6B3667636D798FA053D43BD11
## Solution Approach

Run the following function -
```solidity
function retract() public contacted {
        codex.length--;
    }
```
this will create the array size max which is the size of stack 
i.e. 2**256 - 1;
and we can change the owner address by running the following fuction -
```solidity
 function record(bytes32 _content) public contacted {
        codex.push(_content);
    }

```

