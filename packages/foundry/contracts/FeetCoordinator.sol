// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {WalkNFT} from "./WalkNFT.sol";
import {FeetToken} from "./FeetToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FeetCoordinator is Ownable {
    FeetToken private _feetToken;
    WalkNFT private _walkNFT;

    uint256 public constant INITIAL_MINT_PRICE = 0.0001 ether;
    uint256 public constant PRICE_INCREASE_RATE = 2;
    uint256 public constant MAX_MINT_PRICE = 1 ether;
    uint256 public constant FEET_TO_WALK_PRICE = 2;

    uint256 public totalBurnedWalkNFTs;

    constructor(address feetToken, address walkNFT) Ownable(msg.sender) {
        _feetToken = FeetToken(feetToken);
        _walkNFT = WalkNFT(walkNFT);
    }

    function buyTokens(uint256 amount) public payable {
        uint256 currentPrice = _calculateMintPrice(amount);
        require(msg.value == currentPrice, "Incorrect Ether value");
        _feetToken.mint(msg.sender, amount);
        payable(owner()).transfer(msg.value);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Failed to send Ether");
    }

    function goWalk() public {
        require(
            _feetToken.allowance(msg.sender, address(this)) >=
                FEET_TO_WALK_PRICE,
            "Insufficient $FEET allowance"
        );
        _feetToken.transferFrom(msg.sender, address(this), FEET_TO_WALK_PRICE);
        _walkNFT.safeMint(msg.sender);
    }

    function endWalk(uint256 tokenId) public {
        require(
            _walkNFT.ownerOf(tokenId) == msg.sender,
            "You don't own this Walk NFT"
        );

        // Burn the Walk NFT
        _walkNFT.burn(tokenId);

        // Decrease the $FEET token price
        totalBurnedWalkNFTs++;
    }

    function _calculateMintPrice(
        uint256 amount
    ) internal view returns (uint256) {
        uint256 tokensMinted = _feetToken.totalSupply();
        uint256 currentPrice = INITIAL_MINT_PRICE *
            (PRICE_INCREASE_RATE * tokensMinted) *
            amount;

        // Calculate the reduction factor for burned NFTs (10% reduction per burn)
        uint256 reductionFactor = totalBurnedWalkNFTs * 10;

        // Reduce the current price by the calculated reduction factor
        currentPrice -= (currentPrice * reductionFactor) / 100;

        if (currentPrice > MAX_MINT_PRICE) {
            currentPrice = MAX_MINT_PRICE;
        }
        return currentPrice;
    }

    function getCostPerToken() public view returns (uint256) {
        return _calculateMintPrice(1);
    }
}
