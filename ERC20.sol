
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract ERC20contract is ERC20 {

    constructor(string memory _name, string memory symbol) ERC20(_name, symbol)  {
        _mint(msg.sender, 100000000000000000*10**18);
    }
}
