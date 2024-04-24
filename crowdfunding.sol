// SPDX-License-Identifier: Unlicensed
pragma solidity ^0.8;

contract campaignFactory{
    address[] public deployedCampaigns;
    event campaignCreated(string title, uint requiredAmount, address indexed owner, address campaignAddress, string imageURI, uint indexed timestamp, string indexed category);
    function createCampaign(string memory campaingnTitle, uint requiredCampaignAmount, string memory imageURI, string memory storyURI) public  {
      campaign newCampaign = new campaign(campaingnTitle, requiredCampaignAmount, imageURI, storyURI);
     deployedCampaigns.push(address(newCampaign));
     emit campaignCreated(campaingnTitle, requiredCampaignAmount, msg.sender, address(newCampaign), imageURI, block.timestamp, storyURI);
    }

}
contract campaign {
    string public title;
    uint public requiredAmount;
    string public image;
    string public story;
    address payable public owner;
    uint public receivedAmount;

    constructor(string memory _title, uint _requiredAmount, string memory imageURI,
    string memory storyURI) {
        title = _title;
        requiredAmount =  _requiredAmount;
        image = imageURI;
        story = storyURI;
        owner = payable(msg.sender);

    }

    event _donate(address indexed donar, uint indexed amount, uint indexed timestamp);

    function donate() public payable {
        require(requiredAmount > receivedAmount, "requiredAmount has to be greater than receivedAmount");
        owner.transfer(msg.value);
        receivedAmount += msg.value;
        emit _donate(msg.sender, msg.value, block.timestamp);

    }
}

