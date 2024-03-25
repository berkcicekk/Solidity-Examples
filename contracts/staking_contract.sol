// SPDX-License-Identifier: MIT

/**
 * @author 0xberkelfreud
 * @dev Staking Contract
 */

pragma solidity >=0.7.0 <0.9.0;


contract StakingContract {
    IERC20 public immutable stakingToken;
    IERC20 public immutable rewardsToken;

    address public owner;

    uint constant public rewardPerToken = 1;

    mapping(address => uint) public balanceOf;

    mapping(address => uint) public durations;

    mapping(address => uint) public rewards;

    constructor(address _stakingToken, address _rewardsToken) {
        owner = msg.sender;
        stakingToken = IERC20(_stakingToken);
        rewardsToken = IERC20(_rewardsToken);
    }

    modifier updateReward(address _account) {
        rewards[_account] += calculateReward(_account);
        durations[_account] = block.timestamp;
        _;
    }

    function calculateReward(address _account) view internal returns(uint){
        uint duration = block.timestamp - durations[_account];
        return balanceOf[_account] * duration * rewardPerToken;
    }

   function stake(uint _amount) external updateReward(msg.sender){
    require(_amount > 0, "miktar = 0");
    
    // Stake edilen miktarın %10'u kadar ek ödül miktarını hesaplayın
    uint additionalReward = _amount * 10 / 100;
    
    // Kullanıcının bakiyesine stake edilen miktarı ve ek ödülü ekleyin
    balanceOf[msg.sender] += _amount + additionalReward;

    // Kullanıcının staking tokenlarını kontrata transfer edin
    stakingToken.transferFrom(msg.sender, address(this), _amount);
}

    function withdraw(uint _amount) external updateReward(msg.sender){
        require(_amount > 0, "amount = 0");
        require(balanceOf[msg.sender] > 0, "Your balance = 0");
        balanceOf[msg.sender] -= _amount;
        stakingToken.transfer(msg.sender, _amount);
    }

    function getReward() external updateReward(msg.sender){
        uint reward = rewards[msg.sender];
        require(reward > 0, "You dont have rewards");
        rewards[msg.sender] = 0;
        rewardsToken.transfer(msg.sender, reward);
    }
}


interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}
