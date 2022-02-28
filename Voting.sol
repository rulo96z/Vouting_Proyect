pragma solidity ^0.5.0;

contract Voting{

    address payable owner;

    struct candidate{
        uint id;
        string name;
        uint voteCount;
    }
    
    uint candidateCount;
    mapping(uint => candidate) public candidates; 
    mapping(address => address) public voterRegistrationCard; //maps voterAddress to VRC token
    mapping(address => bool) public registered; //voter is registered or not
    mapping(address => bool) public voted; //voter has voted or not
    address [] registrations; //array of voter addresses

    event eventVote(uint indexed candidateID);
    
    modifier restricted(){
        require(msg.sender == owner, "You do not have authorization!");
    }

    constructor() public{
        owner = msg.sender;
    }

    function addCandidate(string memory candidateName) public restricted {
        candidateCount++;
        candidates[candidateCount] = candidate(candidateCount, candidateName, 0);
    }
    
    function editCandidate(uint256 id, string memory candidateName) public restricted{
        candidates[id] = candidate(id, candidateName, candidates[id].voteCount);
    }

    function vote(uint candidateID) public {
        require(msg.sender == ownerof(voterRegistrationCard[msg.sender]), "You do not have a valid VoterRegistrationCard!")
        require(!voted[msg.sender], "You have already voted!");
        require(candidateID > 0 && candidateID <= candidateCount, "Please select a valid candidate!");
        voted[msg.sender] = true;
        candidates[candidateID].voteCount++;

        emit eventVote(candidateID);
    }

    function newVote() public restricted{
        candidateCount = 0;
        for (uint i=0; i< registrations.length ; i++){
            voted[registrations[i]] = false;
        }
    }
}