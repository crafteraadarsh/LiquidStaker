# Staker Contract functionality

**This contract is a StakingRewards contract implemented in Solidity. It’s designed to allow users to stake tokens and earn rewards over time. It integrates with the Uniswap V2 permit functionality to enable gasless token approvals. Here’s a detailed breakdown of its components and functionality:**

### The Staking contract allow user to -
- Stake his tokens and earned reward.
- Withdraw staked tokens.
- Claim rewards.


# Imports Some openZepplin library

- ## SafeMath 
 **It is provides a set of arithmetic operations with built-in safety checks to prevent overflow and underflow errors in smart contracts and also provide more security.**

 - ## ERC20Detailed
 **The ERC20Detailed library from OpenZeppelin provides a standardized way to describe ERC-20 tokens with additional metadata.ERC20Detailed adds optional metadata that can be useful for users and interfaces.**

 - ## SafeERC20

 ***It enhances the functionality of ERC-20 tokens by adding safety checks for token operations.***

 - ## ReentrancyGuard

 ***This library is very important for any samrt contract because ReentrancyGuard is  provided by OpenZeppelin that prevents reentrancy attacks by ensuring that a function cannot be called again before the previous execution is complete.***

# State Variable for the StakingReward Contract

## IERC20 public rewardsToken

**This variable holds the address of the ERC20 token that will be used as the reward token**

## IERC20 public StakingToken

**This variable holds the address of the ERC20 token that users will stake in the contract.**

## uint256 public periodFinish

**This variable tracks the end time of the current reward period.**

## uint256 public rewardRate

**This variable defines the rate at which rewards are distributed per second.**

## uint256 public rewardDuration = 60 days

**This variable sets the duration of the reward period, defaulting to 60 days. It determines how long the current reward rate will be in effect before it can be updated.**

## uint256 public lastUpdateTime

**This variable records the last time when the reward calculations were updated.**

## mapping(address => uint256) public userRewardPerTokenPaid

**This mapping simply keeps track of the reward per token that each user has been paid up to the last update and also helps in calculating how much reward a user has earned since the last update.**

## mapping(address => uint256) public rewards

**This mapping keeps track of how many rewards each user has earned but hasn't claimed yet. It gets updated whenever rewards are added or when a user claims their rewards.**

## uint256 private _totalSupply

**This variable holds the total amount of tokens currently staked in the contract. As you know, private variables can only be modified by internal functions.**

## mapping(address => uint256) private _balances

**This private mapping tracks the amount of tokens staked by each individual user.**

 ## // ========== CONSTRUCTOR ========== //

 Purpose: The constructor is used to set the initial values for the state variables when the contract is deployed.

 -  _rewardsDistribution : The _rewardsDistribution address is like a special admin or manager that has permission to update and manage the rewards given out by the contract.

 - _rewardsToken : This is the address of the ERC20 token that will be used to distribute rewards to users.

 - _stakingToken : This is the address of the ERC20 token that users will stake. It represents the token that users deposit into the contract to earn rewards.

 ## // ====== VIEWS FUNCTIONS ====== //

 - **totalSupply() : Return the total Supply of the contract.**

 - **balanceOf(): The balanceOf function is used to check the amount of tokens that a specific user (or account) has staked in the contract.**

 - **lastTimeRewardApplicable() : This function returns the most recent time at which rewards are applicable, ensuring that rewards are only calculated up to the end of the current reward period.**

 - **rewardPerToken() : This function calculates how much reward each token has earned based on the total amount of tokens staked and the current reward rate.**

 - **earned() : Calculates the total reward earned by an account.**

 - **getRewardForDuration() : It provides a straightforward way to see how much reward is allocated for the entire duration of the reward period, giving a clear picture of the total rewards available to be distributed.**

 ##  /* ========== MUTATIVE FUNCTIONS ========== */

 - **stakeWithPermit() : The function allows users to stake tokens in the contract without a separate approval transaction, using Uniswap V2’s permit feature for gasless token approvals. It takes the number of tokens to stake, transfers them from the user’s account to the contract, and emits a blockchain log entry with details about the staking action, making it easier to track state changes.**

 - **stake(): The function simplifies staking by allowing users to stake tokens directly without additional approvals, streamlining the process. It updates the total staked supply and individual user balances, ensuring accurate records. By emitting the Staked event, the function enables real-time tracking of staking activities for external applications, which helps with updating user interfaces, performing analytics, and integrating with other services.**

 - **withdraw(): The withdraw function allows users to withdraw staked tokens and also enables users to withdraw a specified amount of tokens that they had previously staked.**

 - **getReward() : The getReward function in the StakingRewards contract allows users to claim or withdraw any rewards they have earned through staking.**

 - **exit() : The exit function provides a convenient way for users to exit the staking program by handling both token withdrawal and reward claiming in a single transaction. This reduces the number of steps and transactions required by users.**

 ## /* ========== RESTRICTED FUNCTIONS ========== */

**The restricted functions in the StakingRewards contract are designed to be called only by the rewards distribution address. These functions handle the addition of rewards and ensure that the contract operates correctly within the specified constraints and also used for maintaining the integrity and security of the reward distribution mechanism.**

- **notifyRewardAmount() : The notifyRewardAmount function in the StakingRewards contract updates how rewards are distributed to stakers. When this function is called, it calculates a new reward rate based on the provided reward amount. If the current reward period has ended, it sets the rate directly from the new reward. If the period is still ongoing, it adjusts the rate by combining the new reward with any leftover rewards from the previous period. The function also checks that the new reward rate is feasible by comparing it to the contract’s current token balance, ensuring that the contract can cover the rewards without overflow issues. Finally, it updates the internal tracking of reward periods and emits an event to notify about the added reward.**

##  /* ========== MODIFIERS ========== */

- **updateReward : The updateReward modifier in the smart contract ensures that reward calculations are up-to-date before any function it decorates is executed. It refreshes the reward rate, updates the timestamp of the last reward calculation, and recalculates individual user rewards. This ensures that users receive accurate rewards based on the most recent data and maintains consistency in reward distribution.**

##  /* ========== EVENTS ========== */

 **Events in the StakingRewards contract are crucial for transparent and trackable interactions with the contract. They provide real-time updates on staking, withdrawals, reward additions, and payouts, enabling better monitoring and user engagement.**