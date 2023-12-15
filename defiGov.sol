// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./ERC20.sol";

contract defineGovToken {
    address public owner;

    struct Voting {
        uint votingId;
        bool votingPowerGiven;
        uint voteValue;
        bool voted;
    }

    struct addAsMember{
       uint contribution;
       uint tenureWanted;
       bool memberAdded;
    }

    ERC20 public governanceToken;
    address[] public members;
    uint public votingPowerCounter;

    mapping(address => addAsMember) public Member;
    mapping(uint => Voting) public VotingPoweer;

    constructor(address tokenAddress) public {
        governanceToken = ERC20(tokenAddress);
        votingPowerCounter = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner has access");
        _;
    }

    function AddMember(uint _contribution, uint _tenureWanted) public onlyOwner{
        require(!Member[msg.sender].memberAdded, "Already added");
        require(_contribution >= 100, "amount must be equal or greater than 100");

        Member[msg.sender] = addAsMember ({
            contribution: _contribution,
            tenureWanted: _tenureWanted,
            memberAdded: true
        });
        members.push(msg.sender);
        governanceToken.transferFrom(msg.sender, address(this), _contribution);
    }

    function votingPoweer(uint _votingId, uint _voteValue) public onlyOwner {
        require(!Member[msg.sender].memberAdded, "Already added");
        require(!VotingPoweer[votingPowerCounter].votingPowerGiven, "already voted");
        require(_voteValue == 1, "vote value has to be 1 for all members");

        VotingPoweer[votingPowerCounter] = Voting ({
          votingId: _votingId,
          voteValue: _voteValue,
          votingPowerGiven: true,
          voted: false
        });
    }

    function quorumRequireent(uint votesRequired) public onlyOwner {
        require(!Member[msg.sender].memberAdded, "echo Already added");
        require(VotingPoweer[votingPowerCounter].votingPowerGiven, "echo already voted");
        require(VotingPoweer[votingPowerCounter].voted, "echo Already voted");
        require(votesRequired * 100 >= 1 * members, "quarum not met");
        VotingPoweer[votingPowerCounter].voted = true;
    }
}
