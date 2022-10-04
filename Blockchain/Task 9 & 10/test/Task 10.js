const { expect, assert } = require("chai");
const { BigNumber } = require("ethers");

describe("Task 10", function () {
  it("Test out all the functions of the contract", async function () {
    const [owner, owner1, owner2] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Task10");
    const hardhatToken = await Token.deploy("EQN", "Eqan", 18, 1000);
    let ownerBalance = await hardhatToken.BalanceOf(owner.address);
    let owner1Balance = await hardhatToken.BalanceOf(owner1.address);
    let owner2Balance = await hardhatToken.BalanceOf(owner2.address);
    let value = 100;
    // Testing Functionalities

    // Total Supply
    let totalSupply = await hardhatToken.TotalSupply();
    // expect(totalSupply).to.equal(ownerBalance);

    // Transfer
    await hardhatToken.Transfer(owner1.address, owner2.address, value);
    let newBalance = BigNumber.from(owner1Balance).add(BigNumber.from(value*0.85));
    owner1Balance = await  hardhatToken.BalanceOf(owner1.address)
    console.log("Actual Balance: ", owner1Balance)
    console.log("Expected Balance: ", newBalance)
    expect(owner1Balance).to.equal(newBalance);
  });
});