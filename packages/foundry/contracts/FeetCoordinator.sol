pragma solidity ^0.8.0;

import {WalkNFT} from "./WalkNFT.sol";
import {FeetToken} from "./FeetToken.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract FeetCoordinator is Ownable {
    FeetToken private _feetToken;
    WalkNFT private _walkNFT;

    uint256 public constant INITIAL_MINT_PRICE = 0.0001 ether;
    uint256 public constant PRICE_INCREASE_RATE = 10;
    uint256 public constant MAX_MINT_PRICE = 1 ether;
    uint256 public constant FEET_TO_WALK_PRICE = 2;

    uint256 public constant INITIAL_DECREASING_POWER = 1; // Initial Walk NFT decreasing power
    uint256 public constant FINAL_DECREASING_POWER = 10; // Final Walk NFT decreasing power
    uint256 public constant DECREASING_POWER_THRESHOLD = 1000; // Threshold to switch from initial to final decreasing power

    uint256 public totalBurnedWalkNFTs;

    constructor(address feetToken, address walkNFT) Ownable(msg.sender) {
        _feetToken = FeetToken(feetToken);
        _walkNFT = WalkNFT(walkNFT);
    }

    function buyTokens(uint256 amount) public payable {
        uint256 currentPrice = _calculateMintPrice(amount);
        require(
            currentPrice <= MAX_MINT_PRICE,
            "Total cost exceeds maximum mint price"
        );
        require(msg.value == currentPrice, "Incorrect Ether value");
        _feetToken.mint(msg.sender, amount);
        payable(owner()).transfer(msg.value);
    }

    function goWalk() public {
        require(
            _feetToken.balanceOf(msg.sender) >= FEET_TO_WALK_PRICE,
            "Insufficient $FEET balance"
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
            (PRICE_INCREASE_RATE ** tokensMinted) *
            amount;

        // Adjust mint price based on the number of burned Walk NFTs
        currentPrice -= totalBurnedWalkNFTs * 1000; // Decrease the mint price by 1000 wei for each burned Walk NFT

        if (currentPrice > MAX_MINT_PRICE) {
            currentPrice = MAX_MINT_PRICE;
        }
        return currentPrice;
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Failed to send Ether");
    }
}
