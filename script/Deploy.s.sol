// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/RewardToken.sol";
import "../src/StakingToken.sol";
import "../src/StakingContract.sol";

contract DeployScript is Script {
    function run() external {
        // Update the private key from the environment variable for Ropsten
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        // Start broadcasting transactions
        vm.startBroadcast(deployerPrivateKey);

        // Deploy contracts
        RewardToken rewardToken = new RewardToken(1000000 * 1e18);
        StakingToken stakingToken = new StakingToken(1000000 * 1e18);
        StakingContract stakingContract = new StakingContract(
            address(stakingToken),
            address(rewardToken),
            1e18
        );

        // Stop broadcasting transactions
        vm.stopBroadcast();

        // Log contract addresses
        console.log("RewardToken deployed at:", address(rewardToken));
        console.log("StakingToken deployed at:", address(stakingToken));
        console.log("StakingContract deployed at:", address(stakingContract));
    }
}
