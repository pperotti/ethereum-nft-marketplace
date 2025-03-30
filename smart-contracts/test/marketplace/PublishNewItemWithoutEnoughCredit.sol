// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract PublishNewItemWithoutEnoughCredit is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    // Try to publish a new item as contract owner
    function test() public payable {
        // Test 
        try mkpContract.publish{value: 20000}("test", "https://google.com/img1", "1234567890", true, 0.05 ether) {
            assertTrue(false, "This operation should have failed on a paused contract!");
        } catch Error(string memory reason) {
            assertTrue(true, reason);
        }  
    }

}
