import './App.css'
import React, { useState } from 'react';
import { ethers } from "ethers";
import { contractABI, contractAddress } from "./utils/constants";

/*
  Notes:
  OpenZeppelin is a library that consists of multiple, reusable contracts including puzzles to build ERC20 tokens.

  Types Of ERC20 Token Implementation:

  1. StandardToken is a typical implementation of your ERC20 token.
     StandardToken additionally implements `increaseApproval` and `decreaseApproval` methods, which are safer to use
     than the standard `approval` method due to frontrunning vulnerability.

  2. MintableToken extends StandardToken adding the `mint` method. Minting is the process of creating new tokens out
     of thin air, and only the owner of the token contract can mint new tokens. e.g NFTs

     CappedToken is the extension of the MintableToken and introduces cap, which is a maximal amount of tokens that can
     be minted.
     
     RBACMintableToken allows for managing creators of new tokens.

  3. PausableToken changes StandardToken in the way that transferring tokens is impossible when the token is paused. Only
     the owner can pause and unpause the smart contract.

  ABI (Application Binary Interface) in the context of computer science is an interface between two program
  modules, often between operating systems and user programs.

*/

function App() {
  const [obj,setObj] = useState({
     currentUserWalletAddress:'', 
     currentUserChainID:0, 
     currentUserChainName:'',
     currentUserAccountBalance: 0,
     visible:false
  })

  const decimalToHex = (number) =>
  {
    number = 0xFFFFFFFF + number + 1;
    return number.toString(16).toUpperCase();
  }

  const connectWallet = async() => 
  {
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const USDC_ADDRESS = "0xE0820b992c0B1F3Ab20A272E27bB4e33F6724D25";
    // Read-Only; By connecting to a Provider, allows:
    // - Any constant function
    // - Querying Filters
    // - Populating Unsigned Transactions for non-constant methods
    // - Estimating Gas for non-constant (as an anonymous sender)
    // - Static Calling non-constant methods (as anonymous sender)
    const transactionsContract = new ethers.Contract(USDC_ADDRESS, contractABI, signer);
    const { chainId, name } = await provider.getNetwork()
    const currentUserWalletAddress = await signer.getAddress()
    const currentUserChainID = decimalToHex(parseInt(chainId))
    const bigNumberBalance = await provider.getBalance(currentUserWalletAddress);
    // const erc20 = new ethers.Contract(USDC_ADDRESS, contractABI, provider);
    // const bigNumberBalance = await transactionsContract.balanceOf(currentUserWalletAddress)
    const accountBalance = ethers.utils.formatEther(bigNumberBalance)
    // Transfer Function Call
    await transactionsContract.connect(signer).transfer(contractAddress, 2);
    // TransferFrom: executes transfers of a specified number of tokens from a specified address
    // Transfer From Function Call
    transactionsContract.on("Transfer", (from, to, amount, event) => {
        console.log("Transfer From Function Called!");
    });
    // await erc20.connect(signer).transferFrom();
    setObj({...obj,
      currentUserWalletAddress: currentUserWalletAddress,
      currentUserChainID: currentUserChainID,
      currentUserChainName: name,
      currentUserAccountBalance: accountBalance,
      visible:true
      })
  }
  return (
    <div className="App">
    <header className="App-header">
    <button className='btn btn-primary' onClick={connectWallet}>
      Connect Wallet
    </button>
    {
      obj.visible == true ?
        <a>
          <pre className="lead">
            Current User Wallet Address: {obj.currentUserWalletAddress}
          </pre>
          <pre className="lead">
            Current User Chain ID: {obj.currentUserChainID} 
          </pre>
          <pre className="lead">
            Chain Name: {obj.currentUserChainName}
          </pre>
          <pre className="lead">
            Current Account Balance: {obj.currentUserAccountBalance}
          </pre>
        </a>
       :null
     }
    </header>
    </div>
  )
}

export default App