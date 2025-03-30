// SPDX-License-Identifier: MIT

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Pausable.sol";
import "forge-std/console.sol";

pragma solidity ^0.8.26;

/**
 * Contract to run the marketplace for NFTs. 
 * This contract offers:
 * - Publish (mint) new items in the store
 * - Buy an item available for sale (by paying a specific amount of ETH)
 * - Allow item's owners to change the sale status of an item.
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
    uint256 _publishingPrice = 0.01 ether; // 0.01 Ether 100000

    // Change Status Price
    uint256 _changeStatePrice = 0.01 ether; // 0.01 Ether 100000

    // Structure for the every NFT sold by this Marketplace
    struct MarketItem{        
        string name; // Name
        string imageURI; // URI to retrieve the image 
        string imageShaSum; // Shasum for the content of the image
        bool saleEnabled; // Determine whether the item can be bought or not
        uint256 sellingPrice; // Selling price expressed in Gwei 
    }

    // Tracks the items available for sell
    mapping(uint256 => MarketItem) internal _inventory;
    
    // Inventory's Count
    uint256 _inventoryItemCount;

    constructor() ERC721("Marketplace", "MKTP") Ownable(msg.sender) {}

    // Create a new item for the marketplace 
    function publish(
            string memory _name, 
            string memory _imageUrl, 
            string memory _imageShaSum, 
            bool _saleEnabled,
            uint256 _sellingPrice
        ) public payable whenNotPaused returns (uint256) {
        
        // Validate the publisher has enough ETH
        require(msg.value >= _publishingPrice, "Insufficient ETH provided!");
        
        // Create a MarketItem based on the information received
        MarketItem memory newItem = MarketItem({
            name: _name, 
            imageURI: _imageUrl, 
            imageShaSum: _imageShaSum, 
            saleEnabled: _saleEnabled,
            sellingPrice: _sellingPrice});
    
        // Create a unit tokenID for the new MarketItem based on the timestamp of the block + the sender
        uint256 _tokenId = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));

        // Check is different than zero
        require(_tokenId != 0, "TokenID cannot be zero.");

        // Mint the new item
        _mint(msg.sender, _tokenId);

        // Add the item to the marketplace
        _inventory[_tokenId] = newItem;

        // Add count to the tracker
        _inventoryItemCount++;

        // Set the URI for the new item
        _setTokenURI(_tokenId, _imageUrl);

        return _tokenId;
    }

    // Buy an item 
    function purchase(address _buyerAddress, uint256 _tokenId) public payable whenNotPaused {
                
        // Is the item available for purchase
        require(_inventory[_tokenId].saleEnabled, "This item is not for sale!");

        // Does the user have enough ETH
        require(msg.value >= _inventory[_tokenId].sellingPrice, "Insufficient ETH provided!");

        // Does the item has an owner different than the sender
        require(_ownerOf(_tokenId) != _buyerAddress, "You are already the owner of this item");

        // Approve the buyer's address 
        _approve(_buyerAddress, _tokenId, _ownerOf(_tokenId), false);
        
        // Transfer the item to the buyer's address        
        safeTransferFrom(_ownerOf(_tokenId), _buyerAddress, _tokenId);                
    }

    // Change the amount of items I'm allowed to mint
    function setPublishingPrice(uint256 _newPrice) public payable onlyOwner whenNotPaused {
        require(msg.value >= _changeStatePrice, "Insufficient ETH provided!");
        require(_newPrice > 0, "The publishing price should be greater than zero");
        _publishingPrice = _newPrice;
    }

    // Change the amount of items I'm allowed to mint
    function setChangeStatePrice(uint256 _newPrice) public payable onlyOwner whenNotPaused {
        require(msg.value >= _changeStatePrice, "Insufficient ETH provided!");
        require(_newPrice > 0, "The change status price should be greater than zero");
        _changeStatePrice = _newPrice;
    }

    // Get the publishing price
    function getPublishingPrice() external view returns (uint256) {
        return _publishingPrice;
    }

    // Get the price to change the status
    function getChangeStatePrice() external view returns (uint256) {
        return _changeStatePrice;
    }

    // Change "saleEnabled" status
    function setSaleEnabled(uint256 _tokenId, bool _saleEnabled) external whenNotPaused {
        // Validate you must be the owner of the item to change it
        require(ownerOf(_tokenId) == msg.sender, "You must be the owner of this item for it to be changed");
        
        // Change the sale status of the item
        _inventory[_tokenId].saleEnabled = _saleEnabled;
    }

    // Override the baseTokenURI value. 
    // Evaluate whether we need token uri for this or not.
    function setBaseTokenURI(string memory _newBaseURI) public onlyOwner {
        _baseTokenURI = _newBaseURI;
    }

    // This is the base url where metadata is located. 
    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    // Add getter for the count of items in the inventory
    function getInventoryItemCount() external view whenNotPaused returns (uint256){
        return _inventoryItemCount;
    }

    // Retrieve a MarketItem from the inventory based on the passed tokenId
    function getMarketItem(uint256 _tokenId) public view whenNotPaused returns (MarketItem memory){
        return _inventory[_tokenId];
    }

    // Pause the contract
    function pause() public onlyOwner {
        _pause();
    }

    // Unpause the contract
    function unpause() public onlyOwner {
        _unpause();
    }
}