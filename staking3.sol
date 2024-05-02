// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;


import "./erc20.sol";

contract staking{
    ERC20 public MTT;
    address payable public owner;
    mapping(address=>bool) stakingDone;
    mapping(address=>bool) withdrawDone;
    mapping(address=>bool) distributionDone;
    uint public amount;
    uint public rewardAmount;


    constructor(address _MTT) payable {
        owner = payable(msg.sender);
        MTT = ERC20(_MTT);

    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner has the access");
        _;
    }

    function stake(uint _amount) public payable {
        require(_amount >0, "amount has to be greater than zero");
        require(!stakingDone[msg.sender], "you have already staked");
        MTT.transferFrom(msg.sender, address(this), _amount);
        stakingDone[msg.sender] = false;
        amount += _amount;

    }

        function withdraw_stake(uint _amount) public payable {
        require(_amount <= amount, "amount has to be appropriate");
        require(!withdrawDone[msg.sender], "you have already staked");
        MTT.transfer(msg.sender,  _amount);
        withdrawDone[msg.sender] = false;
        amount -= _amount;

    }


    function calculate_reward() public onlyOwner view returns(uint) {
    
        return amount*10/100;
    }


    function distribute_rewards() public payable onlyOwner{
        require(rewardAmount == calculate_reward(), "rewatd amount should be as per reward calculation");
        require(!distributionDone[msg.sender], "distribution already donr");
        rewardAmount = calculate_reward();
        distributionDone[msg.sender] = false;
        MTT.transfer(msg.sender, rewardAmount);
        amount -= rewardAmount;

    }

    
}
