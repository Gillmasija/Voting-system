pragma solidity ^0.5.16;

contract Voting {
    // Struct to represent a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // Mapping to store candidate information
    mapping(uint256 => Candidate) public candidates;

    // Mapping to track voter addresses and their vote status
    mapping(address => bool) public hasVoted;

    // Event to be emitted when a new election is initiated
    event ElectionInitiated();

    // Event to be emitted when a vote is cast
    event VoteCast(address indexed voter, uint256 candidateId);

    // Address of the authorized election administrator
    address public electionAdministrator;

    // Voting deadline timestamp
    uint256 public votingDeadline;

    // Modifier to restrict function access to the election administrator
    modifier onlyElectionAdministrator() {
        require(msg.sender == electionAdministrator, "Unauthorized access");
        _;
    }

    /**
     * @dev Constructor to initialize the election administrator and voting deadline
