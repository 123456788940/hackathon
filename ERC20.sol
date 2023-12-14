
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract ERC20contract is ERC20 {
    address public realEstateOwner;
    string propertyDetails;
constructor(string memory _name, string memory symbol, address owner, string memory details) ERC20(_name, symbol)  {
realEstateOwner = owner;
propertyDetails = details;
_mint(owner, 100000000000000000*10**18);
}
}
