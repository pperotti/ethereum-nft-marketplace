// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

pragma solidity ^0.8.20;

/**
 * Contract to run the marketplace for NFTs. 
 * This contract offers:
 * - Publish (mint) new items in the store
 * - Buy an existing NFT (by paying a specific amount of ETH)
 * - Allow owners to edit the metadata of their NFTs
 * 
 * @author Pablo Perotti 
 */
contract Marketplace is ERC721URIStorage, Pausable, Ownable {

    // This _baseURI represents the URI where all the NFT data will be retrieved from. 
    // The URI corresponds to a location where all the resources are located in IPFS. 
    // This can be changed in runtime by the owner
    // WARNING: Not sure if this is going to be used: 
    string _baseTokenURI = ""; //https://ipfs.io/ipns/k51qzi5uqu5dkug453svtp6b9dpwve0vmhbyz2yd42ft9n8xwx2hgujtdcb554";

    // Publishing Price 
    uint256 _publishingPrice = 10000000;

    // Structure for the every NFT sold by this Marketplace
    struct MarketItem{        
        string name; // Name
        string imageURI; // URI to retrieve the image 
        string imageShaSum; // Shasum for the content of the image
        uint256 sellingPrice; // Selling price expressed in Gwei 
    }

    // Tracks the items available for sell
    mapping(uint256 => MarketItem) public _inventory;

    constructor() ERC721("Marketplace", "MKTP") Ownable(msg.sender) {}

    // Create a new item for the marketplace 
    function publish(string memory _name, string memory _imageUrl, string memory _imageShaSum, uint256 _sellingPrice) public payable whenNotPaused returns (uint256) {

        // Validate the publisher has enough ETH
        require(msg.value >= _publishingPrice, "Insufficient ETH provided!");
        
        // Create a MarketItem based on the information received
        MarketItem memory newItem = MarketItem({name: _name, imageURI: _imageUrl, imageShaSum: _imageShaSum, sellingPrice: _sellingPrice});
    
        // Create a unit tokenID for the new MarketItem based on the timestamp of the block + the sender
        uint256 _tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));

        // Mint the new item
        _safeMint(msg.sender, _tokenId);

        // Add the item to the marketplace
        _inventory[_tokenId] = newItem;

        return _tokenId;
    }

    // Buy an item 
    function purchase(uint256 _tokenId) public payable whenNotPaused {
        // Validations
        // #1 - Does the user have enough ETH
        // #2 - Is the item still available?


    }

    // Change the amount of items I'm allowed to mint


    // Override the baseTokenURI value
    function setBaseTokenURI(string memory _newBaseURI) public onlyOwner {
        _baseTokenURI = _newBaseURI;
    }

    // This is the base url where metadata is located. 
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }
}