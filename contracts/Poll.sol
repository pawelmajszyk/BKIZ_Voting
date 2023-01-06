pragma solidity ^0.8.0;

contract Poll {
    // Poll struct
    struct PollStruct {
        string name;
        string[] options;
        address[] voters;
        uint[] votes;
    }

    // Mapping from poll ID to poll struct
    mapping(uint => PollStruct) public polls;
    // List of all poll IDs
    uint[] public pollIds;
    // Admin address
    address public admin;

    // Constructor
    constructor() public {
        // Set the contract deployer as the admin
        admin = msg.sender;
    }

    // Function to create a new poll
    function createPoll(string memory name, string[] memory options) public {
        require(msg.sender == admin, "Only the admin can create polls");
        pollIds.push(0);
        uint pollId = pollIds.length - 1;
        polls[pollId] = PollStruct(name, options, new address[](0), new uint[](options.length));
        pollIds[pollId] = pollId;
    }

    // Function to add a voter to a poll
    function addVoter(uint pollId, address voter) public {
        require(msg.sender == admin, "Only the admin can add voters to a poll");
        PollStruct storage poll = polls[pollId];
        require(poll.voters.length == poll.votes.length, "Invalid poll data");
        for (uint i = 0; i < poll.voters.length; i++) {
            require(poll.voters[i] != voter, "Voter has already been added");
        }
        poll.voters.push(voter);
        poll.votes.push(0);
    }

    // Function to cast a vote in a poll
    function vote(uint pollId, uint option) public {
        PollStruct storage poll = polls[pollId];
        require(poll.voters.length == poll.votes.length, "Invalid poll data");
        require(option < poll.options.length, "Invalid option");
        address voter = msg.sender;
        for (uint i = 0; i < poll.voters.length; i++) {
            if (poll.voters[i] == voter) {
                poll.votes[i] = option;
                return;
            }
        }
        // If the voter has not been added to the poll, add them and cast their vote
        addVoter(pollId, voter);
        poll.votes[poll.votes.length - 1] = option;
    }

    // Function to get the results of a poll
    function getResults(uint pollId) public view returns (string memory name, uint[] memory votes, string[] memory options) {
        PollStruct storage poll = polls[pollId];
        name = poll.name;
        votes = poll.votes;
        options = poll.options;
    }
}