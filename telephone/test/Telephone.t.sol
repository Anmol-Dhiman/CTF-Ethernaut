// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Telephone.sol";

contract CounterTest is Test {
    Telephone public telephoneContract;

    function setUp() public {
        telephoneContract = new Telephone();
    }

    function test_ClaimOwnership() public {
        assertEq(telephoneContract.owner(), address(this));
        // Sets the *next* call's msg.sender to be the input address,
        // and the tx.origin to be the second input
        vm.prank(address(this), vm.addr(1));
        telephoneContract.changeOwner(vm.addr(1));
        assertEq(
            uint256(uint160(vm.addr(1))),
            uint256(uint160(telephoneContract.owner()))
        );
    }
}
