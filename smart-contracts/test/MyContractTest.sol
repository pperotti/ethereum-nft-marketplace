// SPDX-License-Identifier: MIT

import "../contracts/MyContract.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract MyContractTest is Test {
    MyContract public myContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        myContract = new MyContract();
    }
    
    // Test minting and transferring an NFT
    function test_mint_and_transfer() public {
        // Test accounts provided by Remix
        address owner = address(this);
        address account1 = address(1);
        uint256 tokenId = 1;

        // Set the balance of owner and account1
        deal(owner, 2 ether);
        deal(account1, 2 ether);

        console.log(owner.balance);
        console.log(account1.balance);

        // Mint NFT to account1
        uint256 additionalAmount = 0.5 ether;
        uint256 newTokenId = myContract.publish{value: additionalAmount}(owner, "testUri");

        //assertEq(address(myContract).balance, sendAmount + additionalAmount);
        
        // Check initial ownership
        assertEq(newTokenId, tokenId);
        
        //vm.prank(account1);
        //myContract.transferFrom(owner, account1, tokenId);

    }

}