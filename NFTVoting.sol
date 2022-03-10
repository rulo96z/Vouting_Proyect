//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;
pragma experimental ABIEncoderV2;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract NFTVoting is ERC721{
        
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address public owner;

    uint256 startTime = block.timestamp;
    uint256 endTime = block.timestamp + 2 weeks;

    struct candidate{
        uint id;
        string name;
        uint voteCount;
    }
    
    uint candidateCount;
    mapping(uint => candidate) public candidates; 
    mapping(address => uint256) public voterRegistrationCard; //maps voterAddress to VRC token
    mapping(address => bool) public registered; //voter is registered or not
    mapping(address => bool) public voted; //voter has voted or not
    address [] private registrations; //array of voter addresses

    event eventVote(uint indexed candidateID);
    
    modifier restricted {
        require(msg.sender == owner, "You do not have authorization!");
        _;
    }
    
    constructor() ERC721("VoterRegistrationCard", "VRC") {
        owner = msg.sender;
        addCandidate("Chocolate");
        addCandidate("Vanilla");
        addCandidate("Strawberry");
    }

    function registerVoter(string memory voterInput) public returns (uint256){
        require(!registered[msg.sender], "You have already registered to vote!");
        require(msg.sender != owner, "Owner can not register!");
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Registration is currently not avaliable!");

        bytes memory input = bytes(voterInput);
        
        _tokenIds.increment();
        uint256 newVoterId = _tokenIds.current();
        _safeMint(msg.sender, newVoterId, input);
        registrations.push(msg.sender);
        registered[msg.sender] = true;
        voterRegistrationCard[msg.sender] = newVoterId;

        return newVoterId;
    }

    function addCandidate(string memory candidateName) public restricted {
        candidateCount++;
        candidates[candidateCount] = candidate(candidateCount, candidateName, 0);
    }
    
    function editCandidate(uint256 id, string memory newCandidateName) public restricted{
        candidates[id] = candidate(id, newCandidateName, candidates[id].voteCount);
    }

    function numCandidates() public view returns(uint){
        return candidateCount;
    }

    function timeLeft() public view returns(uint){
        return endTime - block.timestamp;
    }

    function vote(uint candidateID) public {
        require(msg.sender == ownerOf(voterRegistrationCard[msg.sender]), "You do not have a valid VoterRegistrationCard!");
        require(!voted[msg.sender], "You have already voted!");
        require(msg.sender != owner, "Owner can not vote!");
        require(block.timestamp >= startTime && block.timestamp <= endTime, "Voting is currently not avaliable!");
        require(candidateID > 0 && candidateID <= candidateCount, "Please select a valid candidate!");

        voted[msg.sender] = true;
        candidates[candidateID].voteCount++;

        emit eventVote(candidateID);
    }

    function getNumberOfCandidates() public view returns(uint){
        return candidateCount;
    }
    
    function getName(uint id) public view returns(string memory){
        return candidates[id].name;
    }

    function getVoteCount(uint id) public view returns(uint){
        return candidates[id].voteCount;
    }

    function newVote(uint256 _endTime) public restricted{
        for (uint c=0; c<= candidateCount; c++){
            delete(candidates[c]);
        }
        candidateCount = 0;
        for (uint i=0; i< registrations.length ; i++){
            voted[registrations[i]] = false;
        }
        startTime = block.timestamp;
        endTime = _endTime;
    }

    function deleteRegistrations() public restricted{
        for (uint i=0; i< registrations.length ; i++){
            registered[registrations[i]] = false;
            delete(voterRegistrationCard[registrations[i]]);
            delete(registrations[i]);
        }
    }
}