// Voting.sol
pragma solidity ^0.8.0;

contract Voting {
    address public admin;
    mapping(uint256 => uint256) public votes;

    // Constructor to set the admin when the contract is deployed
    constructor() {
        admin = msg.sender;
    }

    // Modifier to restrict access to the admin
    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Function to start a new election, only callable by the admin
    function startElection(uint256 electionId) external onlyAdmin {
        require(votes[electionId] == 0, "Election ID already exists");
        votes[electionId] = 1; // Initialize with one vote to avoid division by zero later
    }

    // Function to submit a vote for a specific election
    function vote(uint256 electionId) external {
        require(votes[electionId] > 0, "Election does not exist");
        votes[electionId]++;
    }

    // Function to retrieve the result of a specific election
    function getResult(uint256 electionId) external view returns (uint256) {
        require(votes[electionId] > 0, "Election does not exist");
        return votes[electionId] - 1; // Subtract the initial vote
    }
}
