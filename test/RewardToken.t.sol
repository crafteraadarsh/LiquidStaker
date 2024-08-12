// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../src/RewardToken.sol";
import "../src/StakingToken.sol";

contract TokenTestSuite is Test {
    RewardToken private rewardToken;
    StakingToken private stakingToken;

    address private constant USER1 = address(0x123);
    address private constant USER2 = address(0x456);

    function setUp() public {
        rewardToken = new RewardToken(1000 * 1e18);
        stakingToken = new StakingToken(1000 * 1e18);

        // Transfer initial tokens
        rewardToken.transfer(USER1, 500 * 1e18);
        stakingToken.transfer(USER1, 500 * 1e18);
    }

    function testInitialBalances() public {
        uint256 contractRewardBalance = rewardToken.balanceOf(address(this));
        uint256 contractStakingBalance = stakingToken.balanceOf(address(this));

        assertEq(contractRewardBalance, 500 * 1e18, "Initial reward token balance is incorrect");
        assertEq(contractStakingBalance, 500 * 1e18, "Initial staking token balance is incorrect");
    }

    function testTokenTransfer() public {
        vm.startPrank(USER1);

        uint256 user1RewardBefore = rewardToken.balanceOf(USER1);
        uint256 user1StakingBefore = stakingToken.balanceOf(USER1);

        rewardToken.transfer(USER2, 100 * 1e18);
        stakingToken.transfer(USER2, 100 * 1e18);

        assertEq(rewardToken.balanceOf(USER1), user1RewardBefore - 100 * 1e18, "Reward token balance after transfer is incorrect");
        assertEq(rewardToken.balanceOf(USER2), 100 * 1e18, "Reward token balance of USER2 is incorrect");
        assertEq(stakingToken.balanceOf(USER1), user1StakingBefore - 100 * 1e18, "Staking token balance after transfer is incorrect");
        assertEq(stakingToken.balanceOf(USER2), 100 * 1e18, "Staking token balance of USER2 is incorrect");

        vm.stopPrank();
    }

    function testApproveAndTransferFrom() public {
        vm.startPrank(USER1);

        rewardToken.approve(address(this), 100 * 1e18);
        stakingToken.approve(address(this), 100 * 1e18);

        assertEq(rewardToken.allowance(USER1, address(this)), 100 * 1e18, "Allowance for reward token is incorrect");
        assertEq(stakingToken.allowance(USER1, address(this)), 100 * 1e18, "Allowance for staking token is incorrect");

        vm.stopPrank();

        vm.startPrank(address(this));

        rewardToken.transferFrom(USER1, USER2, 100 * 1e18);
        stakingToken.transferFrom(USER1, USER2, 100 * 1e18);

        assertEq(rewardToken.balanceOf(USER1), 400 * 1e18, "Reward token balance after transferFrom is incorrect");
        assertEq(rewardToken.balanceOf(USER2), 100 * 1e18, "Reward token balance of USER2 after transferFrom is incorrect");
        assertEq(stakingToken.balanceOf(USER1), 400 * 1e18, "Staking token balance after transferFrom is incorrect");
        assertEq(stakingToken.balanceOf(USER2), 100 * 1e18, "Staking token balance of USER2 after transferFrom is incorrect");

        vm.stopPrank();
    }

    function testZeroValueTransfer() public {
        vm.startPrank(USER1);

        uint256 user1RewardBefore = rewardToken.balanceOf(USER1);
        uint256 user1StakingBefore = stakingToken.balanceOf(USER1);

        rewardToken.transfer(USER2, 0);
        stakingToken.transfer(USER2, 0);

        assertEq(rewardToken.balanceOf(USER1), user1RewardBefore, "Reward token balance should remain unchanged");
        assertEq(rewardToken.balanceOf(USER2), 0, "Reward token balance of USER2 should remain zero");
        assertEq(stakingToken.balanceOf(USER1), user1StakingBefore, "Staking token balance should remain unchanged");
        assertEq(stakingToken.balanceOf(USER2), 0, "Staking token balance of USER2 should remain zero");

        vm.stopPrank();
    }
}