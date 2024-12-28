// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Crowdfunding {
    // Struct to hold campaign details
    struct Campaign {
        string creatorName;
        string creatorEmail;
        string campaignName;
        uint goal;
        string description;
        address payable creator;
        uint fundsRaised;
    }

    // Array to store all campaigns
    Campaign[] public campaigns;

    // Event emitted when a new campaign is created
    event CampaignCreated(
        uint id,
        string creatorName,
        string creatorEmail,
        string campaignName,
        uint goal,
        string description,
        address creator
    );

    // Event emitted when a contribution is made
    event ContributionMade(
        uint id,
        uint amount,
        address contributor
    );

    // Function to create a new campaign
    function createCampaign(
        string memory _creatorName,
        string memory _creatorEmail,
        string memory _campaignName,
        uint _goal,
        string memory _description
    ) public {
        require(bytes(_creatorName).length > 0, "Creator name is required");
        require(bytes(_creatorEmail).length > 0, "Creator email is required");
        require(bytes(_campaignName).length > 0, "Campaign name is required");
        require(_goal > 0, "Campaign goal must be greater than zero");
        require(bytes(_description).length > 0, "Campaign description is required");

        // Create a new campaign and add it to the array
        campaigns.push(Campaign({
            creatorName: _creatorName,
            creatorEmail: _creatorEmail,
            campaignName: _campaignName,
            goal: _goal,
            description: _description,
            creator: payable(msg.sender),
            fundsRaised: 0
        }));

        // Emit event with new campaign details
        emit CampaignCreated(campaigns.length - 1, _creatorName, _creatorEmail, _campaignName, _goal, _description, msg.sender);
    }

    // Function to contribute to a campaign
    function contribute(uint _id) public payable {
        require(_id < campaigns.length, "Invalid campaign ID");
        require(msg.value > 0, "Contribution must be greater than zero");

        Campaign storage campaign = campaigns[_id];
        campaign.fundsRaised += msg.value;

        // Emit event with contribution details
        emit ContributionMade(_id, msg.value, msg.sender);
    }

    // Function to fetch all campaigns
    function getAllCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }

    // Function to withdraw funds by the campaign creator
    function withdrawFunds(uint _id) public {
        require(_id < campaigns.length, "Invalid campaign ID");

        Campaign storage campaign = campaigns[_id];
        require(msg.sender == campaign.creator, "Only the campaign creator can withdraw funds");
        require(campaign.fundsRaised > 0, "No funds to withdraw");

        uint amount = campaign.fundsRaised;
        campaign.fundsRaised = 0;
        campaign.creator.transfer(amount);
    }

    // Function to get campaign details by ID
    function getCampaignDetails(uint _id) public view returns (
        string memory creatorName,
        string memory creatorEmail,
        string memory campaignName,
        uint goal,
        string memory description,
        uint fundsRaised
    ) {
        require(_id < campaigns.length, "Invalid campaign ID");

        Campaign storage campaign = campaigns[_id];

        return (
            campaign.creatorName,
            campaign.creatorEmail,
            campaign.campaignName,
            campaign.goal,
            campaign.description,
            campaign.fundsRaised
        );
    }
}