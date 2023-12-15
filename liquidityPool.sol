// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "./ERC20.sol";

// Import UniswapV2 interfaces
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Factory.sol";
import "@uniswap/v2-core/contracts/interfaces/IUniswapV2Pair.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";


contract ERC20Contract is ERC20 {
  address public owner;
  modifier onlyOwner {
    require(msg.sender == owner, "only owner has access");
    _;
  }

  IUniswapV2Router02 public uniswapRouter;
  address public uniswapPair;
    

  constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {
    owner = msg.sender;
    IUniswapV2Router02 _uniswapRouter =   IUniswapV2Router02(
      0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
    );
    uniswapRouter = _uniswapRouter;

    uniswapPair =  IUniswapV2Factory(_uniswapRouter.factory()).createPair(
      address(this),
      _uniswapRouter.WETH()
    );
  }

  function addLiquidity(uint amountToken) external onlyOwner {
    _approve(msg.sender, address(uniswapRouter), amountToken);
    uint balance = balanceOf(address(this));
    _transfer(msg.sender, address(this), amountToken);
    uniswapRouter.addLiquidityETH{value: address(this).balance}(
      address(this),
      balance,
      0,
      0,
      owner,
      block.timestamp + 3600
    );
  }

  function swapTokens(uint amountIn, uint amountOutmin) external onlyOwner {
    _approve(msg.sender, address(uniswapRouter), amountIn);
    uniswapRouter.swapExactTokensForTokens(
      amountIn,
      amountOutmin,
      getPath(),
      address(this),
        block.timestamp + 3600
    );
  }

  function getPath() public view returns(address[] memory)  {
    address[] memory path = new address[](2);
    path[0] = address(this);
    path[1] = uniswapRouter.WETH();
    return path;
  }
}