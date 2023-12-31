# Question Statement
This contract utilizes a library to store two different times for two different timezones. The constructor creates two instances of the library for each time to be stored.

The goal of this level is for you to claim ownership of the instance you are given.

  Things that might help

    Look into Solidity's documentation on the delegatecall low level function, how it works, how it can be used to delegate operations to on-chain. libraries, and what implications it has on execution scope.
    Understanding what it means for delegatecall to be context-preserving.
    Understanding how storage variables are stored and accessed.
    Understanding how casting works between different data types.

- Reference ->
https://ethernaut.openzeppelin.com/level/0x2754fA769d47ACdF1f6cDAa4B0A8Ca4eEba651eC

## Solution Approach
provide access to other account from approve and then spend from transferFrom method of erc20.


## Code Setup
Delegate call attack when the data decleration is not same

## Test Code Files

- [Preservation.t.sol](./test/Preservation.t.sol)

# Test Output 
![test output](image.png)

# Code Setup 
``` 
$ forge install
$ forge build
$ forge test -vvvv
```

# Reference 
- [assertEq()](https://book.getfoundry.sh/reference/forge-std/assertEq)
