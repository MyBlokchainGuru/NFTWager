pragma solidity ^0.6.0;

import {ChainlinkVRF} from "@smartcontractkit/chainlink/contracts/src/v0.8/ChainlinkVRF.sol";

contract GameOfNfts {

    address private owner;
    mapping (address => uint) public betAmounts;
    ChainlinkVRF vrf;

    constructor () public {
        owner = msg.sender;
        vrf = new ChainlinkVRF(msg.sender);
    }
    
    //function to allow users to place bets
    function placeBet(address player, uint256 nft1, uint256 nft2) public payable {
        require(msg.value == .05 ether, "Please send .05 ETH to play");
        betAmounts[player] += msg.value;
        //call the VRF to generate random numbers
        (uint256 randomNumber, bytes32 seed) = vrf.generateRandomNumber(player);
        //set conditions to determine winner based on random number
        if (randomNumber >= 0 && randomNumber <= 0.5) {
            //send both NFTs to the winner
            nft1.transfer(player);
            nft2.transfer(player);
            //send the eth to the wallet
            msg.sender.transfer(msg.value);
        }
        else {
            //send both NFTs to the loser
            nft1.transfer(msg.sender);
            nft2.transfer(msg.sender);
        }
    }
}
