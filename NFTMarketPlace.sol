// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8;
// Internal import for nft from openzeppelin
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";


import "hardhat/console.sol";

contract nftMarketPlace is ERC721Enumerable {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenId;
    Counters.Counter private _itemsSlod;

address payable owner;
mapping(uint => MarketItem) private idMarketItem;
uint _listingPrice = 0.25 ether;

struct MarketItem {
    uint tokenId;
    address payable seller;
    address payable owner;
    uint price;
    bool sold;

}

event MarketItemCreated(uint indexed tokenId,
address seller,
address owner,
uint price,
bool sold
);

modifier onlyOwner() {
    require(msg.sender == owner, "only owner can change the listing price");
    _;
}

constructor() ERC721("NFT METAVERSE TOKEN", "MYNFT") {
    _mint(msg.sender, 10 ** 18 * 10000000000000);
    owner = payable(msg.sender);


}

function updateListingPrice(uint listingPrice) public payable onlyOwner{

_listingPrice = listingPrice;

}

function fetchListingPrice() public view returns(uint) {
  return  _listingPrice;
}


// let create NFTToken function 
function createToken(uint price) public payable returns(uint) {
    _tokenId.increment();
    uint newTokenId = _tokenId.current();
    _mint(msg.sender, newTokenId);

    createMarketItem(newTokenId, price);
    return newTokenId;
}
// creating market item
function createMarketItem(uint tokenId, uint price)  private{
    require(price>0, "price must be higher than 0");
    require(msg.value == _listingPrice, "price must be equals to listing price");
    idMarketItem[tokenId] = MarketItem(tokenId,
    payable(msg.sender),
    payable(address(this)),
    price,
    false
    );

   _transfer(msg.sender, address(this), tokenId);
   emit MarketItemCreated(tokenId, msg.sender, address(this), price, false); 



}

// function for resale
function resaleToken(uint tokenId, uint price) public payable {
    require(idMarketItem[tokenId].owner == msg.sender, "only item owner can perform the check");
    require(msg.value == _listingPrice, "price must be equal to listing price");
     idMarketItem[tokenId].sold = false;
     idMarketItem[tokenId].price = price;
     idMarketItem[tokenId].seller = payable(msg.sender);
          idMarketItem[tokenId].seller = payable(address(this));
          _itemsSlod.decrement();
          _transfer(msg.sender, address(this), tokenId);


}
    function createMarketSale(uint tokenId) public payable {
        require(idMarketItem[tokenId].owner == address(this), "The item is not owned by the contract");
        require(msg.value == idMarketItem[tokenId].price, "Incorrect payment amount");
        idMarketItem[tokenId].seller.transfer(msg.value);
        _transfer(address(this), msg.sender, tokenId);
        idMarketItem[tokenId].owner = payable(msg.sender);
        idMarketItem[tokenId].sold = true;
        _itemsSlod.increment();
    }
        function closeSale(uint tokenId) public {
        require(idMarketItem[tokenId].owner == address(this), "The item is not owned by the contract");
        require(!idMarketItem[tokenId].sold, "The item has already been sold");
        _transfer(address(this), idMarketItem[tokenId].seller, tokenId);
        idMarketItem[tokenId].sold = true;
        _itemsSlod.decrement();
    }

    function getBuyer(uint tokenId) public view returns (address) {
        require(idMarketItem[tokenId].sold, "The item is not sold yet");
         return idMarketItem[tokenId].owner;
    }

   
}
