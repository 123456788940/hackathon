// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


contract staking {
    address payable public owner;
    mapping(address=>bool) public stakedAmount;
    mapping(address=>bool) public withdrawnAmount;
    mapping(address=>bool) public _rewardAmount;
    uint public amount;
    constructor() payable {
        owner = payable(msg.sender);

    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function stake(uint _amount) public payable{
        require(_amount > 0, "staking amount has to be greater than zero");
        require(!stakedAmount[msg.sender], "you have staked already");
        payable(owner).transfer(_amount);
        stakedAmount[msg.sender] = false;
        amount += _amount;

    }

     function withdraw_stake(uint _amount) public payable{
        require(_amount <= amount, "staking amount has to be greater than zero");
        require(!withdrawnAmount[msg.sender], "you have staked already");
        payable(msg.sender).transfer(_amount);
        stakedAmount[msg.sender] = false;
        amount -= _amount;

    }

    function calculate_reward() public onlyOwner view returns(uint) {
      
         
      return amount*10/100;

    }

    function distribute_rewards(uint rewardAmount) public payable onlyOwner {
        require(rewardAmount == calculate_reward(), "  rewar amount received");
        require(!_rewardAmount[msg.sender], "you have received the reward already");
        payable(msg.sender).transfer(rewardAmount);
        _rewardAmount[msg.sender] = false;
        amount -= rewardAmount;

    }

    receive  () external payable{

    }


}
