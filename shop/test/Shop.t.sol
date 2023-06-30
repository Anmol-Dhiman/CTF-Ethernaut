// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/Shop.sol";

contract ShopText is Test {
    Shop public victim;
    uint count;

    function setUp() public {
        victim = new Shop();
    }

    function test_GetItemAtLessPrice() public {
        victim.buy();
        assertTrue(victim.price() == 10);
    }

    function price() external view returns (uint) {
        if (!victim.isSold()) {
            return 100;
        }
        return 10;
    }
}
