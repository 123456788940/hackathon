// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract token is ERC20 {
    constructor() ERC20("MTT", "MultichainZ token"){
        _mint(msg.sender, 10000000 * 18 ** 10);
    }
}
