// SPDX-License-Identifier: MIT

import "../../contracts/Marketplace.sol"; // Your main contract

import "forge-std/Test.sol";
import "forge-std/console.sol";
import "forge-std/StdAssertions.sol";

pragma solidity ^0.8.26;

contract CheckTokenNameAndSymbol is Test {
    Marketplace public mkpContract;
    
    // 'beforeAll' runs before all test functions
    function setUp() public {
        mkpContract = new Marketplace();
    }

    // Check the contract name and symbol are the expected
    function test() public view {
        assertEq(mkpContract.name(), "Marketplace", "token name did not match");
        assertEq(mkpContract.symbol(), "MKTP", "token symbol did not match");
    }
}
