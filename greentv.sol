// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GreentvToken is ERC20 {
    address public owner;
    uint256 public initialPrice;
    uint256 public secondMonthPrice;
    uint256 public secondMonthTimestamp;
    uint256 public rateChangeTimestamp;

    constructor() ERC20("Greentv Token", "GTV") {
        owner = msg.sender;
        uint256 totalSupply = 3000000 * (10 ** uint256(decimals())); // Total supply of 3 million tokens
        _mint(msg.sender, totalSupply);
        initialPrice = 5; // Set initial price to 0.05 USD
        secondMonthPrice = 8; // Set second month price to 0.08 USD
        secondMonthTimestamp = block.timestamp + 30 days; // Set second month timestamp to 30 days from deployment
        rateChangeTimestamp = block.timestamp;
    }

    function currentPrice() public view returns (uint256) {
        if (block.timestamp < secondMonthTimestamp) {
            return initialPrice;
        } else {
            return secondMonthPrice;
        }
    }

    function buyTokens(uint256 amountInCents) external {
        require(amountInCents > 0, "Insufficient amount provided");
        uint256 tokens;
        if (block.timestamp < secondMonthTimestamp) {
            tokens = (amountInCents * (10 ** uint256(decimals()))) / initialPrice;
        } else {
            tokens = (amountInCents * (10 ** uint256(decimals()))) / secondMonthPrice;
        }
        _transfer(owner, msg.sender, tokens);
    }

    function withdrawEther() external {
        require(msg.sender == owner, "Only owner can withdraw");
        payable(owner).transfer(address(this).balance);
    }
}
