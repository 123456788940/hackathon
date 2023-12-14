
// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ERC20Token is ERC20 {
    constructor() ERC20("coin token", "ct") {
        _mint(msg.sender, 10000000000000000 * 10 * 18);
    }
}
