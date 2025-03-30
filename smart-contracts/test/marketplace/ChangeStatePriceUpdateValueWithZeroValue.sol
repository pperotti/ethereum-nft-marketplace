// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract ChangeStatePriceUpdateValueWithZeroValue is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    function test() public payable {

        // Preconditions - Set up owner wallet 
        address owner = address(this);
        deal(owner, 0.2 ether);
        uint256 newPrice = uint256(0);
        vm.expectRevert();

        // Test - Set the new price 
        mkpContract.setChangeStatePrice{value: owner.balance}(newPrice);

        // Assert - Compare the new price with the expected one
        uint256 currentPrice = mkpContract.getChangeStatePrice();
        assertEq(currentPrice, 0.01 ether, "Current price does not equal the new price.");
    }

}