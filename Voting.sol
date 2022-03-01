//SPDX-License-Identifier: MIT
pragma solidity  >= 0.4.22 < 0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Detailed.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/token/ERC20/ERC20Mintable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract Voting is ERC721, ERC20, ERC20Detailed, ERC20Mintable{
        
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    address payable owner;

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

    constructor(address _token) ERC721("VoterRegistrationCard", "VRC") ERC20Detailed("VoteToken", "VOTE", 18) {
        mint(msg.sender, 1000000000);
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


    function sendVoteToken() public {
        require(registered[msg.sender] == true, "You have not registered to vote!");
        require(balanceOf(msg.sender) < 1 , "You already have a VoteToken!");
        require(!voted[msg.sender], "You have already recieved a VoteToken!");

        increaseAllowance(msg.sender, 1);
        transfer(msg.sender, 1);
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
        transferFrom(msg.sender, owner, 1);

        emit eventVote(candidateID);
    }

    function newVote() public restricted{
        candidateCount = 0;
        for (uint i=0; i< registrations.length ; i++){
            voted[registrations[i]] = false;
        }
    }
}