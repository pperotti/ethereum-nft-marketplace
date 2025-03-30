// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract PublishingPriceUpdateValueSuccessfully is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    function test() public payable {

        // Preconditions - Set up owner wallet 
        address owner = address(this);
        deal(owner, 1 ether);
        uint256 newPrice = 0.1 ether;

        // Test - Set the new price 
        mkpContract.setPublishingPrice{value: owner.balance}(newPrice);

        // Assert - Compare the new price with the expected one
        uint256 currentPrice = mkpContract.getPublishingPrice();
        assertEq(newPrice, currentPrice, "Current price does not equal the new price.");
    }

}