// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

 contract BoredApeToken is ERC20{
     address public admin;
  constructor() ERC20("BoredApeToken" , "BRT"){
      _mint(msg.sender, 100000 *10 ** 18);
      admin = msg.sender;
  }

  function mint(address to, uint amount) external {
      require (msg.sender ==admin, "you are not admin");
      _mint(to, amount);
  }
 }