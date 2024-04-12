pragma solidity ^0.8.20;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {ERC721Burnable} from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";
import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

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

    function burn(uint256 tokenId) public override onlyOwner {
        // require(_canBurn(tokenId), "Walk NFT is still locked");
        super.burn(tokenId);
    }

    /// @dev Transfers `tokenId` from `from` to `to`.
    function transfer(address to, uint256 tokenId) public {
        _transfer(_msgSender(), to, tokenId);
    }

    function calculateLockDuration(
        uint256 tokenId
    ) internal pure returns (uint256) {
        // Logic to calculate the lock duration based on token ID
        // In this example, we increase the lock duration linearly with the token ID
        return (tokenId * 1 minutes); // Increase lock duration linearly with token ID
    }

    function _canBurn(uint256 tokenId) internal view returns (bool) {
        return block.timestamp >= _lockedUntilBlock[tokenId];
    }

    function getTokenCounter() public view returns (uint256) {
        return _nextTokenId;
    }

    /// @dev Returns the Uniform Resource Identifier (URI) for token `id`.
    function tokenURI(uint256 id) public view override returns (string memory) {
        return _buildTokenURI(id);
    }

    /// @dev Constructs the encoded svg string to be returned by tokenURI()
    function _buildTokenURI(uint256 id) internal view returns (string memory) {
        bytes memory image;
        string memory burnableText;

        if (_canBurn(id)) {
            // If the NFT is burnable
            burnableText = '<text x="20" y="50" style="font-size:20px; fill: red;">THIS WALK CAN BE ENDED</text>';
        } else {
            // If the NFT is not burnable, show the remaining blocks until it can be burned
            uint256 remainingBlocks = _lockedUntilBlock[id] - block.timestamp;
            burnableText = string(
                abi.encodePacked(
                    '<text x="20" y="50" style="font-size:16px;">Remaining blocks until Walk end:</text>',
                    '<text x="20" y="80" style="font-size:20px;">',
                    Strings.toString(remainingBlocks),
                    "</text>"
                )
            );
        }

        image = abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(
                bytes(
                    abi.encodePacked(
                        '<?xml version="1.0" encoding="UTF-8"?>',
                        '<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" version="1.1" viewBox="0 0 400 400" preserveAspectRatio="xMidYMid meet">',
                        '<style type="text/css"><![CDATA[text {font-family: monospace; font-size: 21px; fill: #000000;} .h1 {font-size: 40px; font-weight: 600; fill: "#000000";}]]></style>',
                        '<rect width="400" height="400" fill="#FFFFFF" />',
                        burnableText, // Add burnable text
                        unicode'<text x="40" y="200" style="font-size:40px;">🦶..👣...🐸</text>',
                        unicode'<text x="20" y="350">End your walk,</text>',
                        unicode'<text x="20" y="380">and reduce price by 10%!</text>',
                        "</svg>"
                    )
                )
            )
        );

        return
            string(
                abi.encodePacked(
                    "data:application/json;base64,",
                    Base64.encode(
                        bytes(
                            abi.encodePacked(
                                '{"name":"',
                                name(),
                                '", "image":"',
                                image,
                                unicode'", "description": "Consider this NFT as an eternal thank you note for your donation. Hope to see you building with us in the future! <3"}'
                            )
                        )
                    )
                )
            );
    }
}
