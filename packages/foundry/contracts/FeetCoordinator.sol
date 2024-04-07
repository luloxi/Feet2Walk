pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FeetCoordinator is Ownable {
    IERC20 private feetToken;
    IERC721 private walkNFT;

    constructor(address _feetToken, address _walkNFT) Ownable(msg.sender) {
        feetToken = IERC20(_feetToken);
        walkNFT = IERC721(_walkNFT);
    }

    // Function to allow the coordinator to mint tokens for a price
    function buyTokens(uint256 _amount) public payable {
        // Implement pricing logic here

        // Transfer tokens to the buyer
        feetToken.transfer(msg.sender, _amount);
    }

    function withdraw() public onlyOwner {
        (bool success, ) = payable(owner()).call{value: address(this).balance}(
            ""
        );
        require(success, "Failed to send Ether");
    }
}
