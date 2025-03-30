// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "remix_tests.sol";
import "remix_accounts.sol";
import "../contracts/Marketplace.sol";

// Remix Test
contract MarketplaceTest {

    Marketplace mktContract;

    /// #sender: account-0
    /// #value: 1000000000000000000
    function beforeAll () public {
        mktContract = new Marketplace();
    }

    // Check the contract name and symbol are the expected
    function test_token_name_and_symbol () public {
        Assert.equal(mktContract.name(), "Marketplace", "token name did not match");
        Assert.equal(mktContract.symbol(), "MKTP", "token symbol did not match");
    }

    // Check the contract has 0 items after it was deployed
    function test_initial_item_count () public {
        Assert.equal(mktContract.getInventoryItemCount(), uint256(0), "initial item count does not match");
    }

    // Try to publish a new item as contract owner  
    /// #value: 20000000000000000  
    function test_publish_new_item_as_owner() public payable {

        // Test
        try mktContract.publish{value: 20000000000000000}("test", "https://google.com/img1", "1234567890", true, 0.05 ether) returns (uint256 tokenId) {
            Assert.equal(tokenId != 0, true, "Token ID should be different than zero.");
            Assert.equal(mktContract.getInventoryItemCount(), uint256(1), "initial item count does not match after publishing a new item as owner");
                    
            // Check the returned data is correct
            Marketplace.MarketItem memory item = mktContract.getMarketItem(tokenId);
            Assert.equal(item.name, "test", "returned name does not match");
            Assert.equal(item.imageURI, "https://google.com/img1", "returned description does not match");
            Assert.equal(item.imageShaSum, "1234567890", "returned description does not match");
            Assert.equal(item.saleEnabled, true, "returned sale enabled is incorrect");
            Assert.equal(item.sellingPrice, 0.05 ether, "price should be 0.05");
        } catch Error(string memory err) {
            Assert.equal(err, "-", "Publishing item failed");
        }
    }

    // Try to publish a new item when there contract has been paused
    /// #value: 20000000000000000  
    function test_publish_new_item_as_paused() public payable {

        // Test Preconditions
        mktContract.pause();
        
        // Test 
        try mktContract.publish{value: 20000000000000000}("test", "https://google.com/img1", "1234567890", true, 0.05 ether) {
            Assert.ok(false, "This operation should have failed on a paused contract!");
        } catch Error(string memory reason) {
            Assert.ok(true, reason);
        }        
    }

    // Try to publish an item to the inventory without enough credit
    /// #value: 20000  
    function test_publish_new_item_without_enough_credit() public payable {
        // Test 
        try mktContract.publish{value: 20000}("test", "https://google.com/img1", "1234567890", true, 0.05 ether) {
            Assert.ok(false, "This operation should have failed on a paused contract!");
        } catch Error(string memory reason) {
            Assert.ok(true, reason);
        }        
    }

}
