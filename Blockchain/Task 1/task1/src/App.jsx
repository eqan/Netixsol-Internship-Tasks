import './App.css'
import React, { useState } from 'react';
import { ethers } from "ethers";

function App() {
  const [obj,setObj] = useState({
     currentUserWalletAddress:'', 
     currentUserChainID:0, 
     currentUserChainName:'',
     visible:false
  })

  const decimalToHex = (number) =>
  {
    number = 0xFFFFFFFF + number + 1;
    return number.toString(16).toUpperCase();
  }

  const connectWallet = async() => 
  {
    // Prompt user for account connections
    /*
      A Signer in ethers is an abstraction of an Ethereum Account which can be used to
      sign messages and transactions and send signed transactions to the Ethereum Network
      to execute state changing operations

      Ethereum networks have two identifiers, a network ID and a chain ID. Although they often
      have the same value, they have different uses. Peer-to-peer communication between nodes uses
      the network ID, while the transaction signature process uses the chain ID
    */
    const provider = new ethers.providers.Web3Provider(window.ethereum, "any");
    await provider.send("eth_requestAccounts", []);
    const signer = provider.getSigner();
    const { chainId, name } = await provider.getNetwork()
    const currentUserWalletAddress = await signer.getAddress()
    const currentUserChainID = decimalToHex(parseInt(chainId))
    setObj({...obj,
      currentUserWalletAddress: currentUserWalletAddress,
      currentUserChainID: currentUserChainID,
      currentUserChainName: name,
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
        </a>
       :null
     }
    </header>
    </div>
  )
}

export default App