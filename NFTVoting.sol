//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract Voting is ERC721{
        
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address public owner;

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
    }

    function registerVoter() public returns (uint256){
        require(!registered[msg.sender], "You have already registered to vote!");

        _tokenIds.increment();
        uint256 newVoterId = _tokenIds.current();
        _mint(msg.sender, newVoterId);
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

    function vote(uint candidateID) public {
        require(msg.sender == ownerOf(voterRegistrationCard[msg.sender]), "You do not have a valid VoterRegistrationCard!");
        require(!voted[msg.sender], "You have already voted!");
        require(msg.sender != owner, "Owner can not vote!");
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