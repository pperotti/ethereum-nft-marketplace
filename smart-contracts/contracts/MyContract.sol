// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

//import "hardhat/console.sol";

pragma solidity ^0.8.26;

contract MyContract is ERC721URIStorage, Ownable {
    
    // Instead of Counters.Counter
    uint256 private _tokenIdCounter;

    // Instead of _tokenIdCounter.current()
    uint256 newTokenId = _tokenIdCounter;

    constructor() ERC721("Marketplace", "MKTP") Ownable(msg.sender) {}

    // Modified mint function with additional testing flexibility
    function publish(address to, string memory tokenUri) public payable returns (uint256) {       
        require(msg.value >= 0.05 ether, "Insufficient Ether amount");

        _tokenIdCounter++;
        uint256 newItemId = _tokenIdCounter;

        // Allow minting for contract owner or approved test minters
        _mint(to, newItemId);
        _setTokenURI(newItemId, tokenUri);

        return newItemId;
    }

}