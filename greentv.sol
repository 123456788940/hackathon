
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GreentvToken {
    string public name = "GreentvToken";
    string public symbol = "GTV";
   
    uint256 public totalSupply = 300000000;

    uint256 public priceFirstRound = 5; // 5 cents
    uint256 public priceSecondRound = 8; // 8 cents

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);

    constructor() {
        balanceOf[msg.sender] = totalSupply;
    }

    function getPrice() public view returns (uint256) {
        if (block.timestamp < (30 days)) {
            return priceFirstRound;
        } else {
            return priceSecondRound;
        }
    }

    function transfer(address _to, uint256 _value) public returns (bool success) {
        uint256 totalPrice = _value * getPrice();
        require(_to != address(0), "Invalid address");
        require(balanceOf[msg.sender] >= totalPrice, "Insufficient balance");

        balanceOf[msg.sender] -= totalPrice;
        balanceOf[_to] += totalPrice;

        emit Transfer(msg.sender, _to, totalPrice);
        return true;
    }

    function approve(address _spender, uint256 _value) public returns (bool success) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success) {
        uint256 totalPrice = _value * getPrice();
        require(_from != address(0), "Invalid sender address");
        require(_to != address(0), "Invalid recipient address");
        require(balanceOf[_from] >= totalPrice, "Insufficient balance");
        require(allowance[_from][msg.sender] >= _value, "Allowance exceeded");

        balanceOf[_from] -= totalPrice;
        balanceOf[_to] += totalPrice;
        allowance[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, totalPrice);
        return true;
    }
}
