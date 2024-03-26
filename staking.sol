// SPDX-License-Identifier: MIT
pragma solidity >=0.6.12 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract staking {
    using SafeMath for uint;
     using SafeERC20 for IERC20;
    IERC20 public token;
    address public owner;

    constructor(address _token) {
        owner = msg.sender;
         token = IERC20(_token);
    

    }

    modifier onlyOwner() {
        require(msg.sender==owner, "only owner has access");
        _;
    }

    mapping(address=>bool) public isDeposited;
        mapping(address=>bool) public isWithdrawn;

    function deposit(uint _amount) public onlyOwner{
        require(_amount >0, "amount should be as mentioned");
        require(!isDeposited[msg.sender], "deposit not yet done");
        require(token.transferFrom(msg.sender, address(this), _amount), "transfer not yet done");
        isDeposited[msg.sender] = true;
       

    }


    function withdraw(uint _amount) public onlyOwner{
        require(_amount >0, "amount should be as mentioned");
        require(isDeposited[msg.sender], "deposit not yet done");
        require(!isWithdrawn[msg.sender], "withdraw not yet done");
        require(token.transfer(msg.sender, _amount), "transfer not yet done");
        isWithdrawn[msg.sender] = true;
       

    }

   

    function contractBalance() public view returns(uint) {
        return token.balanceOf(address(this));
    }

   
    function userDepositStatus(address _user) public view returns(bool) {
        return isDeposited[_user];

    }

  


    function withdrawStatus(address _user) public view returns(bool) {
        return isWithdrawn[_user];
    }








}
