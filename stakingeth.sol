// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";


contract StakingContract  {
    IERC20 public token;
    uint public stakingDuration;
    uint public rewardRate;
    address public owner;

    struct Stake {
        uint amount;
        uint startTime;
        
    }

    modifier onlyOwner() {
        require(msg.sender==owner);
        _;
    }
    mapping(address=>Stake) public stakes;
    event Staked(address indexed user, uint amount);
    event WithDrawn(address indexed user, uint amount);
    event RewardPaid(address indexed user, uint amount);




    constructor(address _token, uint _stakingDuration, uint _rewardRate) {
        token = IERC20(_token);
        stakingDuration = _stakingDuration;
        rewardRate=_rewardRate;
    }


    function stake(uint amount) public {
        require(amount>0, "Amount must be greater than 0");
        require(stakes[msg.sender].amount == 0, "Cannot stake multiple times");
        require(token.transferFrom(msg.sender, address(this), amount), "Transfer failed");
        stakes[msg.sender] = Stake(amount, block.timestamp);
        emit Staked(msg.sender, amount);

    }

 
    function withdraw() public {
        require(stakes[msg.sender].amount>0, "No stake withdrawn");
        require(block.timestamp >= stakes[msg.sender].amount + stakingDuration, "staking duration not completed");
        uint amount = stakes[msg.sender].amount;
        delete stakes[msg.sender];
        require(token.transfer(msg.sender, amount), "Transfer failed");
        emit WithDrawn(msg.sender, amount);
    }

    function claimReward() public {
        require(stakes[msg.sender].amount>0, "No stake to claim reward");
        require(block.timestamp >= stakes[msg.sender].startTime + stakingDuration, "staking duration completed");
        uint reward = calculateRewards(msg.sender);
        delete stakes[msg.sender];
        require(token.transfer(msg.sender, reward), "Transfer failed");
        emit RewardPaid(msg.sender, reward);
    }


    function calculateRewards(address user) public view returns (uint) {
        uint stakedAmount = stakes[user].amount;
        uint stakingTime = block.timestamp - stakes[user].startTime;
        uint reward = (stakedAmount * rewardRate * stakingTime) / (365 days);
        return reward;
    }

    function setRewardRate(uint256 _rewardRate) external onlyOwner {
        rewardRate = _rewardRate;
    }

    function setStakingDuration(uint256 _stakingDuration) external onlyOwner {
        stakingDuration = _stakingDuration;
    }

    function rescueTokens(address tokenAddress, address to, uint256 amount) external onlyOwner {
        require(tokenAddress != address(token), "Cannot rescue staked token");
        IERC20(tokenAddress).transfer(to, amount);
    }
}
