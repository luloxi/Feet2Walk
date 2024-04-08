pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./WalkNFT.sol";

contract FeetCoordinator is Ownable {
    IERC20 private _feetToken;
    WalkNFT private _walkNFT;

    uint256 public constant INITIAL_MINT_PRICE = 0.0001 ether;
    uint256 public constant PRICE_INCREASE_RATE = 10;
    uint256 public constant MAX_MINT_PRICE = 100 ether;
    uint256 public constant FEET_TO_WALK_PRICE = 2;
    uint256 public constant INITIAL_DECAY_FACTOR = 10000; // Initial decay factor
    uint256 public constant DECAY_RATE = 1000; // Decay rate per block
    uint256 public constant MIN_DECAY_FACTOR = 100; // Minimum decay factor

    uint256 public totalBurnedWalkNFTs; // Total number of burned Walk NFTs
    uint256 private _deploymentBlock; // Block number when the contract is deployed

    constructor(address feetToken, address walkNFT) Ownable(msg.sender) {
        _feetToken = IERC20(feetToken);
        _walkNFT = WalkNFT(walkNFT);
        _deploymentBlock = block.number; // Record the block number when the contract is deployed
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
        _feetToken.burn(FEET_TO_WALK_PRICE);
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

    function endWalkAndBuyTokens(uint256 tokenId, uint256 amount) public {
        // Ensure the sender owns the Walk NFT
        require(
            _walkNFT.ownerOf(tokenId) == msg.sender,
            "You don't own this Walk NFT"
        );

        // Burn the Walk NFT
        _walkNFT.burn(tokenId);

        // Decrease the $FEET token price
        totalBurnedWalkNFTs++;

        // Calculate the current price for the given amount of tokens
        uint256 currentPrice = _calculateMintPrice(amount);
        require(
            currentPrice <= MAX_MINT_PRICE,
            "Total cost exceeds maximum mint price"
        );

        // Transfer the tokens to the sender
        _feetToken.mint(msg.sender, amount);
    }

    function _calculateMintPrice(
        uint256 amount
    ) internal view returns (uint256) {
        uint256 tokensMinted = _feetToken.totalSupply();
        uint256 currentPrice = INITIAL_MINT_PRICE *
            (PRICE_INCREASE_RATE ** tokensMinted) *
            amount;

        // Calculate the decay factor based on the number of blocks since deployment
        uint256 blocksSinceDeployment = block.number - _deploymentBlock;
        uint256 decayFactor = INITIAL_DECAY_FACTOR -
            (blocksSinceDeployment * DECAY_RATE);
        decayFactor = decayFactor < MIN_DECAY_FACTOR
            ? MIN_DECAY_FACTOR
            : decayFactor; // Ensure the decay factor does not go below the minimum

        // Adjust mint price based on the decay factor
        currentPrice -= totalBurnedWalkNFTs * decayFactor; // Decrease the mint price by decayFactor wei for each burned Walk NFT

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
