// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ERC1155Contract is ERC1155, Ownable {

    constructor(string memory uri) ERC1155(uri) {
        // Mint an initial supply of tokens to the owner
        _mint(msg.sender, 1, 100000000000000000); // Minting 100 tokens with ID 1
    }

    function mint(address to, uint256 tokenId, uint256 amount) external onlyOwner {
        _mint(to, tokenId, amount);
    }
}
