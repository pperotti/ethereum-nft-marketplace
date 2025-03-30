// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract PublishNewItemAsOwnerSuccessfully is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    // Try to publish a new item as contract owner
    function test() public payable {
        // Test
        try mkpContract.publish{value: 20000000000000000}("test", "https://google.com/img1", "1234567890", true, 0.05 ether) returns (uint256 tokenId) {
            assertEq(tokenId != 0, true, "Token ID should be different than zero.");
            assertEq(mkpContract.getInventoryItemCount(), uint256(1), "initial item count does not match after publishing a new item as owner");
                    
            // Check the returned data is correct
            Marketplace.MarketItem memory item = mkpContract.getMarketItem(tokenId);
            assertEq(item.name, "test", "returned name does not match");
            assertEq(item.imageURI, "https://google.com/img1", "returned description does not match");
            assertEq(item.imageShaSum, "1234567890", "returned description does not match");
            assertEq(item.saleEnabled, true, "returned sale enabled is incorrect");
            assertEq(item.sellingPrice, 0.05 ether, "price should be 0.05");
        } catch Error(string memory err) {
            assertEq(err, "-", "Publishing item failed");
        }
    }

}
