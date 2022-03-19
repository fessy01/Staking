//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";

contract BoredApeStake {
    IERC721 public boredApeNFT;
    IERC20 public _token;
    // uint constant secPerDay = 86400;
    uint constant SecPerMonth = 2592000;
  struct  Stakes {
        uint amount;
        uint timeStaked;
        uint minimumTimeDue;
        bool staked;
    }
    event StakesEvent (address staker, uint _amount, uint _timeStaked);
    event ViewStakes(address staker, Stakes);
    event Withdrawal (address staker, uint _amount);

    mapping(address => Stakes) public records;

    constructor(address token){
        _token = IERC20(token);
        boredApeNFT = IERC721(0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D);
    }
    function interestCalc(uint _amount,uint _timeStaked, uint _timeStakeLimit, uint _presentTime) public pure returns (uint){
        if(_presentTime > _timeStakeLimit){
            uint length = _presentTime - _timeStaked;
            uint monthNumber = length/ SecPerMonth;
            if(monthNumber > 1 ){
               uint interest = (_amount * 1/10) * monthNumber;
               return interest;
            }else {
               uint interest = (_amount * 1/10) * 3;
               return interest;
            }
        }else{
            return 0;
        }
       
    }

    function stake (uint _amount) public returns (bool) {
         require(_amount > 0, "stake at least one token");
        uint256 tokenBalance = _token.balanceOf(msg.sender);
        require(tokenBalance>= _amount, "You do not have enough tokens");
          uint256 nftBalance = boredApeNFT.balanceOf(msg.sender);
        require(nftBalance > 0, "Only Ape NFT owner can stake" );
        bool transferred = _token.transferFrom(msg.sender, address(this), _amount);
        require(transferred, "Token Transfer Failed");
        Stakes storage user = records[msg.sender];
        if(records[msg.sender].staked){
            uint interest = interestCalc(user.amount, user.timeStaked, user.minimumTimeDue, block.timestamp);
            uint _totalDue = interest + _amount + records[msg.sender].amount;
            user.amount = _totalDue;
            user.timeStaked = block.timestamp;
            user.minimumTimeDue = block.timestamp + 259200;
        } else{
            user.amount = _amount;
            user.timeStaked = block.timestamp;
            user.minimumTimeDue = block.timestamp + 259200;
            user.staked = true;
        }
        emit StakesEvent (msg.sender, _amount,  block.timestamp);
        return true;
    }


      function withDrawAll() public returns (bool) {
        require (records[msg.sender].amount > 0, "You need to stake to withdraw");
        Stakes storage user= records[msg.sender];
        uint interest = interestCalc(user.amount,user.timeStaked, user.minimumTimeDue,block.timestamp);
        uint totalWithdrawal;
        totalWithdrawal = user.amount + interest;
        user.staked = false;
         _token.transfer(msg.sender, totalWithdrawal);
        emit Withdrawal  (msg.sender, totalWithdrawal);
        return true;
    }

     function withAnAmount(uint _amount) public returns (bool) {
        require (records[msg.sender].amount > 0, "You need to stake to withdraw");
        Stakes storage user= records[msg.sender];
        uint interest = interestCalc(user.amount,user.timeStaked, user.minimumTimeDue,block.timestamp);
        uint totalRemaining;
        totalRemaining = user.amount + interest;
        require(totalRemaining > _amount, "insuffiecient balance");
        user.amount = totalRemaining - _amount;
        user.timeStaked = block.timestamp;
        user.minimumTimeDue = block.timestamp + 259200;
         _token.transfer(msg.sender, _amount);
        emit Withdrawal(msg.sender, _amount);
        return true;
    }

      function withdrawOnlyInterests () public returns (bool) {
        require (records[msg.sender].amount > 0, "You need to stake to withdraw");
        Stakes storage user= records[msg.sender];
        uint interest = interestCalc(user.amount,user.timeStaked, user.minimumTimeDue,block.timestamp);
        _token.transfer(msg.sender, interest );
        user.timeStaked = block.timestamp;
        user.minimumTimeDue = block.timestamp + SecPerMonth;
        emit Withdrawal  (msg.sender, interest );
        return true;
    }

    function viewStake() public returns (bool) {
        require (records[msg.sender].amount > 0, "You need to stake");
        Stakes memory user= records[msg.sender];
        emit ViewStakes(msg.sender, user);
        return true;
    }
}