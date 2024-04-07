//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "../contracts/FeetToken.sol";
import "../contracts/WalkNFT.sol";
import "../contracts/FeetCoordinator.sol";

import "./DeployHelpers.s.sol";

contract DeployScript is ScaffoldETHDeploy {
    error InvalidPrivateKey(string);

    function run() external {
        uint256 deployerPrivateKey = setupLocalhostEnv();
        if (deployerPrivateKey == 0) {
            revert InvalidPrivateKey(
                "You don't have a deployer account. Make sure you have set DEPLOYER_PRIVATE_KEY in .env or use `yarn generate` to generate a new random account"
            );
        }
        vm.startBroadcast(deployerPrivateKey);
        FeetToken feetToken = new FeetToken(vm.addr(deployerPrivateKey));
        WalkNFT walkNFT = new WalkNFT(vm.addr(deployerPrivateKey));
        FeetCoordinator feetCoordinator = new FeetCoordinator(
            address(feetToken),
            address(walkNFT)
        );

        feetToken.transferOwnership(address(feetCoordinator));
        walkNFT.transferOwnership(address(feetCoordinator));
        vm.stopBroadcast();

        /**
         * This function generates the file containing the contracts Abi definitions.
         * These definitions are used to derive the types needed in the custom scaffold-eth hooks, for example.
         * This function should be called last.
         */
        exportDeployments();
    }
}
