// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.5.0;

import "forge-std/Test.sol";
import "../src/AlienCodex.sol";

contract CounterTest is Test {
    AlienCodex victim;

    function setUp() public {
        victim = new AlienCodex();
    }
}
