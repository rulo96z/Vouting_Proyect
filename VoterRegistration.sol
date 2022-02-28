pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Counters.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/IERC721Receiver.sol";

contract VoterRegistrationCard is ERC721, IERC721Receiver {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    constructor() public ERC721("VoterRegistrationCard", "VRC") {

    }

    function registerVoter(address voter, string memory tokenURI) public returns (uint256){
        _tokenIds.increment();
        uint256 newVoterId = _tokenIds.current();
        _mint(voter, newVoterId);
        _setTokenURI(newVoterId, tokenURI);

        return newVoterId;
    }
    
    /**
     * Always returns `IERC721Receiver.onERC721Received.selector`.
     */
    function onERC721Received(address, address, uint256, bytes memory) public virtual override returns (bytes4) {
        return this.onERC721Received.selector;
    }
}
