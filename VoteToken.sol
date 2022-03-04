//SPDX-License-Identifier: MIT
pragma solidity ^0.8.12;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract VoteToken is ERC20 {
    
    constructor() ERC20("VoteToken", "VOTE") {
        _mint(address(this), 1000000000);
    }

    function getToken(address payable voter) public{
        increaseAllowance(voter, 1);
        voter.transfer(1);
    }

    function returnToken(address payable voter) public{
        payable(address(this)).transfer(1);
        decreaseAllowance(voter, 1);
    }
    
}