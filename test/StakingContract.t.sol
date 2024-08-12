// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/StakingContract.sol";
import "../src/StakingToken.sol";

contract StakingContractTestSuite is Test {
    RewardToken private rewardToken;
    StakingContract private stakingContract;
    StakingToken private stakingToken;

    address private constant USER1 = address(0x123);
    uint256 private constant INITIAL_STAKING_TOKENS = 500 * 1e18;
    uint256 private constant INITIAL_REWARD_TOKENS = 500 * 1e18;
    uint256 private constant STAKE_AMOUNT = 100 * 1e18;
    uint256 private constant WITHDRAW_AMOUNT = 100 * 1e18;

    function setUp() public {
        stakingToken = new StakingToken(INITIAL_STAKING_TOKENS);
        rewardToken = new RewardToken(INITIAL_REWARD_TOKENS);
        stakingContract = new StakingContract(
            address(stakingToken),
            address(rewardToken),
            2 * 1e18 
        );

        stakingToken.transfer(USER1, STAKE_AMOUNT);
        rewardToken.transfer(USER1, STAKE_AMOUNT);
    }

    function testUserCanStakeTokens() public {
        vm.startPrank(USER1);

        stakingToken.approve(address(stakingContract), STAKE_AMOUNT);
        stakingContract.stake(STAKE_AMOUNT);

        uint256 userStakedBalance = stakingContract.balanceOf(USER1);
        uint256 userTokenBalance = stakingToken.balanceOf(USER1);

        assertEq(userStakedBalance, STAKE_AMOUNT, "User's staked balance should be equal to the staked amount");
        assertEq(userTokenBalance, STAKE_AMOUNT - STAKE_AMOUNT, "User's token balance should decrease by the staked amount");

        vm.stopPrank();
    }

    function testUserCanWithdrawTokens() public {
        vm.startPrank(USER1);

        stakingToken.approve(address(stakingContract), STAKE_AMOUNT);
        stakingContract.stake(STAKE_AMOUNT);

        stakingContract.withdraw(STAKE_AMOUNT);

        uint256 userStakedBalance = stakingContract.balanceOf(USER1);
        uint256 userTokenBalance = stakingToken.balanceOf(USER1);

        assertEq(userStakedBalance, 0, "User's staked balance should be zero after withdrawal");
        assertEq(userTokenBalance, STAKE_AMOUNT + STAKE_AMOUNT, "User's token balance should return to original after withdrawal");

        vm.stopPrank();
    }

    function testRewardAccumulation() public {
        vm.startPrank(USER1);

        stakingToken.approve(address(stakingContract), STAKE_AMOUNT);
        stakingContract.stake(STAKE_AMOUNT);

        vm.warp(block.timestamp + 1 days);

        stakingContract.getReward();
        uint256 userRewardBalance = rewardToken.balanceOf(USER1);

        assertGt(userRewardBalance, 0, "User should have accumulated rewards after staking for a period");

        vm.stopPrank();
    }

    function testInitialRewardPerToken() public {
        uint256 rewardPerToken = stakingContract.rewardPerToken();

        assertEq(rewardPerToken, 0, "Reward per token should be zero initially when no tokens are staked");
    }

    function testRewardPerTokenAfterStaking() public {
        vm.startPrank(USER1);

        stakingToken.approve(address(stakingContract), STAKE_AMOUNT);
        stakingContract.stake(STAKE_AMOUNT);

        vm.warp(block.timestamp + 1 days);

        uint256 rewardPerTokenAfterStaking = stakingContract.rewardPerToken();
        
        assertGt(rewardPerTokenAfterStaking, 0, "Reward per token should increase after staking for a period");

        vm.stopPrank();
    }
}