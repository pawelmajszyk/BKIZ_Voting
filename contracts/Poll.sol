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

    // Mapping of option id -> to address and bool to check if user voted
     mapping(uint => mapping(address => bool)) public voted;


    // Constructor
    constructor() public {
        // Set the contract deployer as the admin
        admin = msg.sender;
        string[] memory choices = new string[](3);
        choices[0] = "Opcja1";
        choices[1] = "Opcja2";
        choices[2] = "Opcja3";
        createPoll("Ankieta 1", choices);
        createPoll("Ankieta 2", choices);
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
        for (uint i = 0; i < poll.voters.length; i++) {
            require(poll.voters[i] != voter, "Voter has already been added");
        }
        poll.voters.push(voter);
    }

    // Function to cast a vote in a poll
     function vote(uint pollId, uint option) public {
        PollStruct storage poll = polls[pollId];

        for (uint i = 0; i < poll.voters.length; i++) {
            if (poll.voters[i] == msg.sender) {
                require(option < poll.options.length, "Invalid option");
                address voter = msg.sender;
                for (uint j = 0; j < poll.voters.length; j++) {
                     if (poll.voters[j] == voter) {
                            require(!voted[pollId][msg.sender], "You have already voted in this poll");
                            voted[pollId][msg.sender] = true;

                            poll.votes[j] = option;
                            return;
                        }
                    }
         }
        }

        // Sender's address is not in the array, throw an error
        require(false, "Sender address is not allowed");
    }

    // Function to get the results of a poll
    function getResults(uint pollId) public view returns (string memory name, uint[] memory votes, string[] memory options) {
        PollStruct storage poll = polls[pollId];
        name = poll.name;
        votes = poll.votes;
        options = poll.options;
    }
}