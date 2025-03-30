// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract SaleEnabledChangedSuccessfully is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    function test() public payable {

        // Preconditions - Set wallets
        address owner = address(this);
        address buyer = address(1);
        deal(owner, 1 ether);

        // Preconditions - Mint Item as Owner 
        uint256 tokenId = mkpContract.publish{value: owner.balance}("test", "https://google.com/img1", "1234567890", true, 0.05 ether);

        // Change on sale state
        address currentOwner = mkpContract.ownerOf(tokenId);
        assertEq(currentOwner , owner);

        vm.prank(buyer);
        vm.expectRevert();

        // Test - Purchase the item using account 1
        mkpContract.setSaleEnabled(tokenId, false);

        // Assertions - Validate the new owner
        Marketplace.MarketItem memory item = mkpContract.getMarketItem(tokenId);
        assertEq(true, item.saleEnabled, "The new owner of the item should be the buyer's account.");
    }

}