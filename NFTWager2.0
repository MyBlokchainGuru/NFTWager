pragma solidity ^0.5.0;

import "https://github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC721/ERC721.sol";

contract WagerNFT is ERC721 {
  constructor() public {
    // Set name and symbol for our NFT
    _mint(msg.sender, 1, "WagerNFT");
    _mint(msg.sender, 2, "WagerNFT");
  }
}

contract WagerDapp {
  // Address of the NFT contract
  WagerNFT private nft;

  // Mapping of pending wagers
  mapping(bytes32 => address) public pendingWagers;

  // Mapping of resolved wagers
  mapping(bytes32 => address) public resolvedWagers;

  constructor(address _nftAddress) public {
    nft = WagerNFT(_nftAddress);
  }

  // Function to create a new wager between two users
  function createWager(address _player1, address _player2) public {
    // Generate a random bytes32 value to identify the wager
    bytes32 wagerId = keccak256(abi.encodePacked(now, _player1, _player2));

    // Set the wager as pending
    pendingWagers[wagerId] = address(0);

    // Transfer the NFTs to the contract as collateral
    nft.safeTransferFrom(_player1, address(this), 1);
    nft.safeTransferFrom(_player2, address(this), 2);
  }

  // Function to resolve a pending wager and transfer the NFTs to the winner
  function resolveWager(bytes32 _wagerId, address _winner) public {
    // Check if the wager exists and is pending
    require(pendingWagers[_wagerId] == address(0), "Wager does not exist or is not pending");

    // Transfer the NFTs to the winner
    nft.safeTransferFrom(address(this), _winner, 1);
    nft.safeTransferFrom(address(this), _winner, 2);

    // Set the wager as resolved and store the winner's address
    resolvedWagers[_wagerId] = _winner;

    // Delete the wager from the pending wagers mapping
    delete pendingWagers[_wagerId];
  }

  // Function to view the details of a pending wager
  function viewPendingWager(bytes32 _wagerId) public view returns (address player1, address player2) {
    // Get the player addresses from the wager ID
    (, player1, player2) = abi.decode(keccak256(_wagerId), (bool, address, address));
  }
}
