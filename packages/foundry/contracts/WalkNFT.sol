// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^4.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract WalkNFT is ERC721, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => uint256) private _mintBlockNumber; // Mapping to store the block number when each NFT is minted

    constructor(
        address initialOwner
    ) ERC721("Walk NFT", "WALK") Ownable(initialOwner) {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _mintBlockNumber[tokenId] = block.number; // Record the block number when minting
        _safeMint(to, tokenId);
    }

    function blocksSinceMint(uint256 tokenId) public view returns (uint256) {
        require(_exists(tokenId), "Token ID does not exist");
        return block.number - _mintBlockNumber[tokenId]; // Calculate the number of blocks since minting
    }
}
