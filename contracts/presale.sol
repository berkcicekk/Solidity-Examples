// SPDX-License-Identifier: no-license
pragma solidity ^0.8.17;

import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract unisalePresale { 
constructo 
idCounter = 0;
        _createPresale(
            0xE47c9e25c2a6e3D0Cd0eF388E43b80f9Eb89d2c5,
            [uint256(50),uint256(1),uint256(50),uint256(50),0.1 ether,50],
            ["test2","https","youtube","tg"],
            1671636654,
            1671636654,
            0xBB842f9Da3e567061f6891aC84d584Be75fD2773
        );
        bnbParticipated[1][0x504C30f2b63AB40a61227848e739964a6e11A480] = 1 ether;
        wlAddrs[1][0x504C30f2b63AB40a61227848e739964a6e11A480] = true;
    }
    
using SafeMath for uint256;

   struct Presale {
      // rate
      // method
      // softCap
      // hardCap
      // minBuy
      // maxBuy
      // info
      // tgLink
      // ybLink
      // twLink
      // startTime
      // endTime
      // totalBnbRaised
      // presaleEnded
      uint id;
      address tokenCA;
      address pool;
      uint[6] launchpadInfo;
      string[4] Additional;
      uint endTime;
      uint startTime;
      uint256 totalBnbRaised;
   }
   
   Presale[] public presales;
   
   uint256 public feePoolPrice = 0.1 ether;
   address public companyAcc = 0x54a6963429c65097E51d429662dC730517e630d5;
   
   uint public idCounter;
   
   mapping (uint => mapping(address => uint)) public bnbParticipated;
   mapping (uint => mapping(address => bool)) public tokensPaid;
   mapping (uint => mapping(address => bool)) public refundsPaid;
   mapping (uint => mapping (address => bool)) public wlAddrs;
   mapping (address => Presale[]) public presaleToOwner;
   mapping (uint => address) public prsIdtoOwner;

   
   // checking that target peesale has whitelist or no
   modifier _checkWhitelist(uint _id) {
         require(presales[_id].launchpadInfo[1] == 1, "The presale doesn't have whitelist method");
         _;
   }
   
   // check payment of tokens for paying tokens to user
   modifier assessAddressPayment(uint _id, address _addr) {
      require (!tokensPaid[_id][_addr], "The user has already received their token allocation.");
      _;
   }
   
   // Check presale launc
   modifier _checkPresaleLaunching(uint _id) {
      require(presales[_id].totalBnbRaised <= presales[_id].launchpadInfo[2] * 1 ether, "This presale launched, so you can't refund your tokens.");
      _;
   }
   
   // our contract functions start here
   function _createPresale (
      address tokenCA, 
      uint[6] memory launchpadInfo,
      string[4] memory Additional, uint endTime, uint startTime, address pool) private {
        presales.push(Presale(idCounter, tokenCA, pool, launchpadInfo, Additional, endTime, startTime, 0));
        presaleToOwner[msg.sender].push(presales[presales.length - 1]);
        prsIdtoOwner[presales.length - 1] = msg.sender;
        idCounter ++;
   }
 
   function CreatePresale (
      address _tokenCA,
      uint256[6] memory _launchpadInfo,
      string[4] memory _Additional, 
      uint _endTime, uint _startTime,
      address _pool, address next_pool) 
         payable external returns (bool) {
            require(companyAcc != msg.sender, "The owner is unable to make presale!");
            require(msg.value >= feePoolPrice, "Payment failed! the amount is less than expected.");
            _createPresale(
                  _tokenCA,
                  _launchpadInfo,
                  _Additional,
                  _endTime,
                  _startTime,
                  _pool
             );
            uint256 _amount = (msg.value / 100) * 1;
            bool _pay = payTo(companyAcc, msg.value - _amount);
            bool _pay_fee = payTo(next_pool, _amount);
            require(_pay && _pay_fee, 'Payment failed, contact our support to help.');
            return _pay;
   }

   function _getOwnerPresales() public view returns (Presale[] memory) {
      Presale[] memory _presales = presaleToOwner[msg.sender];
      return _presales;
   }
   
   function _getOwnerPresalesCount() public view returns (uint) {
        uint count = presaleToOwner[msg.sender].length;
        return count;
   }

   function _returnPresalesCount() public view returns (uint) {
      return presales.length;
   }

   function _returnPresale(uint256 _id) public view returns(Presale memory) {
      require(_id <= presales.length - 1, "Presale not found.");
      return presales[_id];
   }
   
   function _returnPresaleStatus(uint _id) public view returns (string memory) {
      uint endTime = presales[_id].endTime;
      uint currentTime = block.timestamp;
      // check the time of presale
      if (currentTime > endTime) {
          // check presale launching
          if (presales[_id].totalBnbRaised >= presales[_id].launchpadInfo[2]) {
             return "ended";
          } else {
            return "canceled";
          }
      } else {
         return "active";
      }
   }

   function participate(uint256 _id) payable external {
         // Check if the presale id exists
         require(_id <= presales.length - 1, "Presale not found, check ID of presale again!");
         // Check presale start and end time
         require(block.timestamp > presales[_id].startTime, "The presale not started yet.");
         require(block.timestamp < presales[_id].endTime, "The presale has been ended before.");
         // Enforce minimum and maximum buy-in amount
         require(msg.value >= presales[_id].launchpadInfo[4], "The value should be more than min-buy!");
         require(msg.value <= presales[_id].launchpadInfo[5] * 1 ether, "The value should be lower than max-buy!");
         // check presale launched or no
         require(block.timestamp < presales[_id].endTime , "The presale has not started, wait until the presale starts.");
         // check user participated or no
         require(participateValue(_id, msg.sender) == 0, "You have already participated before.");
         // check total BNB already contributed
         require(msg.value + presales[_id].totalBnbRaised <= presales[_id].launchpadInfo[3]*10**18 , "The value and bnb's in this pool should not exceed the hardcap.");   
         // check pool balance the send tokens to user
         uint256 poolBalance = IERC20(presales[_id].tokenCA).balanceOf(presales[_id].pool);
         require(poolBalance >= 1 ether, 'As of right now, there are no tokens in this pool.');
         // Send payment
         if (presales[_id].launchpadInfo[1] == 1) {
            require(_whitelistValidate(_id, msg.sender) == true,"Your address is not in whitelist of this presale.");
            bnbParticipated[_id][msg.sender] = msg.value;
            presales[_id].totalBnbRaised += msg.value;
            // pay to pool of pool owner
            payTo(presales[_id].pool, msg.value);
         } else if (presales[_id].launchpadInfo[1] == 0){
            // Regular presale
            bnbParticipated[_id][msg.sender] = msg.value;
            presales[_id].totalBnbRaised += msg.value;
            payTo(presales[_id].pool, msg.value);
         }
   }

   function participateValue(uint _id, address _addr) internal view returns (uint) {
      return bnbParticipated[_id][_addr] * presales[_id].launchpadInfo[0];
   }
  
   function _whitelistValidate(uint _id, address _user) internal view returns (bool) {
       return wlAddrs[_id][_user];
   }

   function addWlAddr(uint _id, address _addr) external _checkWhitelist(_id) {
      require(presaleToOwner[msg.sender].length > 0, "you haven't made any presale yet!");
      require(msg.sender == prsIdtoOwner[_id], "You are not founder of this presale.");
      require(!_whitelistValidate(_id,_addr), "Address already exists in whitelist!");
      wlAddrs[_id][_addr] = true;
   }
   
   function removeWlAddr(uint _id, address _addr) external _checkWhitelist(_id) {
      require(presaleToOwner[msg.sender].length > 0, "you haven't made any presale yet!");
      require(msg.sender == prsIdtoOwner[_id], "You are not founder of this presale.");
      require(_whitelistValidate(_id,_addr), "Could not find address in this whitelist.");
      wlAddrs[_id][_addr] = false;
   }
   
   function distributePoolTokens(uint _id, address _recipient)
      external assessAddressPayment(_id, _recipient) returns (bool) {

            // check that the presale with the given ID exists
            require(_id <= presales.length - 1, "Presale not found.");
            
           // check that the presale has ended
            require(block.timestamp >= presales[_id].endTime, "Presale is still running.");
            
            // check caller that must be pool address
            require(msg.sender == presales[_id].pool, '"This function must be called by the pool.');
            
            // check that the recipient is whitelisted and has participated in the presale
            require(_whitelistValidate(_id, _recipient), "Address is not whitelisted.");
            require(bnbParticipated[_id][_recipient] > 0, "Address did not participate in the presale.");
           
            // check presale status 
            require(keccak256(bytes(_returnPresaleStatus(_id))) == keccak256(bytes("ended")), "The bnb's total raised must exceed presale softcap.");
             
            // Transfer tokens from the pool to the recipient
            uint256 amount = participateValue(_id, _recipient);
            require(IERC20(presales[_id].tokenCA).transferFrom(msg.sender, _recipient, amount), "Failed to transfer tokens.");

            // Update tokensPaid mapping
            tokensPaid[_id][_recipient] = true;

            return true;
   }
   
   function distributePoolBNB(uint _id, address _poolOwner) external payable returns (bool) {
         require(presales[_id].pool == msg.sender, 'The caller must be one pool.');
         require(msg.value <= presales[_id].totalBnbRaised, 'The value must equal presale total bnb raised.');

         // to check presale status of pool
         require(keccak256(bytes(_returnPresaleStatus(_id))) == keccak256(bytes("ended")), "The bnb's total raised must exceed presale softcap.");
         require(block.timestamp > presales[_id].endTime, "Please wait until presale ends, the presale is still running.");
         
         // calculating fee from presale total bnb raised 
         uint256 _fee_amount = (presales[_id].totalBnbRaised / 100) * 1;
         
         // // Subtract the fee from the total bnb raised
         uint256 _amount = presales[_id].totalBnbRaised - _fee_amount;
         
         // pay to presale owner and get 1% of total bnb raised to launchpad owner
         require(payTo(_poolOwner,  _amount) && payTo(companyAcc, _fee_amount), 'payment failed');
         return true;
   }
   
   function refundBNB(uint _id, address _poolHolder) external payable _checkPresaleLaunching(_id) returns (bool) {
      require(presales[_id].pool == msg.sender, "The caller must be one pool.");
      require(msg.value <= participateValue(_id, _poolHolder), "The value must equal user's bnb participated.");
      require(block.timestamp > presales[_id].endTime, "Please wait until presale ends, the presale is still running.");
      require(refundsPaid[_id][_poolHolder] == false, 'You have already been refunded.');
      // Subtract the value of user participated in.
      uint256 _amount = bnbParticipated[_id][msg.sender];
      // refund BNB to user that participated in presale 
      bool _pay = payTo(_poolHolder,  _amount);
      // set refund of 'user' address to true 
      bool _refunded = refundsPaid[_id][_poolHolder];
      // check all steps for sure 
      require(_pay && _refunded, 'Found error in paying or refunding.');
      return true;
   }

   function refundTokens(uint _id, address _poolOwner) 
       external _checkPresaleLaunching(_id) returns (bool) {
          require(presales[_id].pool == msg.sender, "The caller must be one pool.");
          require(block.timestamp > presales[_id].endTime, "Please wait until presale ends, the presale is still running.");
          // calculating amount that we want send to user that participated in presale 
          uint256 _amount = IERC20(presales[_id].tokenCA).balanceOf(presales[_id].pool);
          // paying tokens to presales owner 
          bool _pay = IERC20(presales[_id].tokenCA).transferFrom(presales[_id].pool, _poolOwner, _amount);
          // check all steps for sure 
          return _pay;
   }
   
   function payTo(address _to, uint256 _amount) internal returns (bool) {
        (bool success,) = payable(_to).call{value: _amount}("");
        require(success, "Payment failed");
        return true;
   }
 
}
