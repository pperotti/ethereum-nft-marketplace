// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;
import "remix_tests.sol";
import "../contracts/MyToken.sol";

contract MarketplaceTest {

    Marketplace s;
    function beforeAll () public {
        s = new Marketplace();
    }

    function testTokenNameAndSymbol () public {
        Assert.equal(s.name(), "Marketplace", "token name did not match");
        Assert.equal(s.symbol(), "MTK", "token symbol did not match");
    }
}