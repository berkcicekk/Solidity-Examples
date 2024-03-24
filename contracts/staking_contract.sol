pragma solidity 0.5.16;

contract Staking {
    using SafeMath for uint256;

    address public tokenAddress;
    uint256 public totalStaked;
    uint256 public startBlock;
    // uint256 public incBlock; //local testing purpose only
    address public thisGuy;

    IERC20 public ERC20Interface;
