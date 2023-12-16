// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC721Contract is ERC721, Ownable {

    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {
        // Mint an initial token to the owner
        _mint(msg.sender, 1);
    }

    function mint(address to) external onlyOwner {
        uint256 tokenId = totalSupply() + 1;
        _mint(to, tokenId);
    }
}
