pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";

contract VoterRegistrationCard is ERC721 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("VoterRegistrationCard", "VRC") {

    }

    function registerVoter() public returns (uint256){
        _tokenIds.increment();
        uint256 newVoterId = _tokenIds.current();
        _mint(msg.sender, newVoterId);
        return newVoterId;
    }
}
