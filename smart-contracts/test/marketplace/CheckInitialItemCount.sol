// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract PublishNewItemWhenContractIsPaused is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    // Check the contract has 0 items after it was deployed
    function test() public view {
        assertEq(mkpContract.getInventoryItemCount(), uint256(0), "initial item count does not match");
    }

}
