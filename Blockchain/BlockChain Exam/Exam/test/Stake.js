const { expect, assert } = require("chai");
const { BigNumber } = require("ethers");
const { mnemonicToEntropy } = require("ethers/lib/utils");

describe("Stake", function () {
  it("Test out all the functions of the contract", async function () {
    const [owner, owner1, owner2] = await ethers.getSigners();

    // User Token Deployment
    let Token = await ethers.getContractFactory("UserToken");
    const userToken = await Token.deploy();

    // BuySell Token Deployment
    Token = await ethers.getContractFactory("BuySell");
    const buySellToken = await Token.deploy(userToken.address);

    // Buy Functions Testing
    let price = 1000;
    await buySellToken.buyTokens(price);
    
    // Sell Functions Testing
    let tokens = 100;
    await buySellToken.sellTokens(tokens);

    // Stake Token Deployment
    Token = await ethers.getContractFactory("Stake");
    const stakeToken = await Token.deploy(buySellToken.address);

    // Stake
    await stakeToken.stake(owner1, tokens);
    
    // Unstake
    await stakeToken.unstake(owner1);

    // Claim
    await stakeToken.stake(owner2, tokens);
    await stakeToken.claim(owner2);
    

  });
});