// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./ERC20.sol";

contract defineGovToken {
    ERC20 public governanceToken;
    struct Voting {
    uint  votingId;
    bool votingPowerGiven;
    uint voteValue;
    bool voted;
    }
     uint public members;
     uint public votingPowerCounter;

    struct addAsMember{
       uint contribution;
       uint tenureWanted;
       bool memberAdded;
        }

    mapping(address => addAsMember) public Member;
    mapping(uint => Voting) public VotingPoweer;

    constructor(address tokenAddress) {
        governanceToken = ERC20(tokenAddress);
        votingPowerCounter = 0;
    }

    function AddMember(uint _contribution, uint _tenureWanted) public {
        require(!Member[msg.sender].memberAdded, "Already added");
        require(_contribution >= 100, "amount must be equal or greater than 100");

        Member[msg.sender] = addAsMember ({

        
     contribution: _contribution,
     tenureWanted: _tenureWanted,
   
     memberAdded: true
   

    });
    members++;


    governanceToken.transferFrom(msg.sender, address(this), _contribution);
 

    
    }


    function votingPoweer(uint _votingId, uint _voteValue) public  {
            require(Member[msg.sender].memberAdded, "Already added");
        require(!VotingPoweer[votingPowerCounter].votingPowerGiven, "already voted");
        require(_voteValue == 1, "vote value has to be 1 for all members");

        VotingPoweer[votingPowerCounter] = Voting ({
          votingId:  _votingId,
          voteValue: _voteValue,
          votingPowerGiven: true,
            voted: false

        });
    }


    function quorumRequirement(uint votesRequired, uint totalMembers) public  {
         require(Member[msg.sender].memberAdded, "Already added");
           require(VotingPoweer[votingPowerCounter].votingPowerGiven, "already voted");
           require(VotingPoweer[votingPowerCounter].voted, "Already voted");
        require(votesRequired * 100 >= 1 * totalMembers, "quarum not met");
        VotingPoweer[votingPowerCounter].voted = true;
    }
 





}
