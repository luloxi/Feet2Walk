pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract WalkNFT is ERC721, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    mapping(uint256 => uint256) private _mintBlockNumber; // Mapping to store the block number when each NFT is minted
    mapping(uint256 => uint256) private _lockedUntilBlock; // Mapping to store until which block each NFT is locked

    constructor(
        address initialOwner
    ) ERC721("Walk NFT", "WALK") Ownable(initialOwner) {}

    function safeMint(address to) public onlyOwner {
        uint256 tokenId = _nextTokenId++;
        _mintBlockNumber[tokenId] = block.number; // Record the block number when minting
        _lockedUntilBlock[tokenId] =
            block.timestamp +
            calculateLockDuration(tokenId); // Set the locking duration for the NFT
        _safeMint(to, tokenId);
    }

    function burn(uint256 tokenId) public override {
        require(_canBurn(tokenId), "Walk NFT is still locked");
        super.burn(tokenId);
    }

    function calculateLockDuration(
        uint256 tokenId
    ) internal pure returns (uint256) {
        // Logic to calculate the lock duration based on token ID
        // In this example, we increase the lock duration linearly with the token ID
        return (tokenId * 1 days); // Increase lock duration linearly with token ID
    }

    function _canBurn(uint256 tokenId) internal view returns (bool) {
        return block.timestamp >= _lockedUntilBlock[tokenId];
    }
}
