const { expect, assert } = require("chai");
const { BigNumber } = require("ethers");

describe("Task 9", function () {
  it("Test out all the functions of the contract", async function () {
    const [owner, owner1] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("Task9");
    const hardhatToken = await Token.deploy("EQN", "Eqan", 18, 1000);
    let ownerBalance = await hardhatToken.BalanceOf(owner.address);
    let owner1Balance = await hardhatToken.BalanceOf(owner1.address);
    let value = 100;
    // Testing Functionalities

    // Total Supply
    let totalSupply = await hardhatToken.TotalSupply();
    expect(totalSupply).to.equal(ownerBalance);

    // Transfer
    await hardhatToken.Transfer(owner1.address, value);
    let newBalance = BigNumber.from(owner1Balance).add(BigNumber.from(value));
    expect(await hardhatToken.BalanceOf(owner1.address)).to.equal(newBalance);

    // Mint
    ownerBalance = await hardhatToken.BalanceOf(owner.address);
    newBalance = BigNumber.from(ownerBalance).add(BigNumber.from(value));

    await hardhatToken.Mint(owner.address, value);
    ownerBalance = await hardhatToken.BalanceOf(owner.address);
    // console.log("Actual Balance:" + ownerBalance)
    // console.log("Expected Balance:" + newBalance)
    assert(ownerBalance.eq(newBalance), "Mint not matched!");

    // Burn
    ownerBalance = await hardhatToken.BalanceOf(owner.address);
    newBalance = BigNumber.from(ownerBalance).sub(BigNumber.from(value));

    await hardhatToken.Burn(owner.address, value);
    ownerBalance = await hardhatToken.BalanceOf(owner.address);
    assert(ownerBalance.eq(newBalance), "Burn not matched!");
    
    // Allowance
    await hardhatToken.Allowance(owner.address, owner1.address);

    // Approve
    await hardhatToken.Approve(owner.address, value);
    
    // Transfer From
    await hardhatToken.TransferFrom(owner.address, owner1.address, value);
    ownerBalance = await hardhatToken.BalanceOf(owner.address);
    newBalance = BigNumber.from(ownerBalance).add(BigNumber.from(value));
    newBalance = BigNumber.from(totalSupply).sub(BigNumber.from(newBalance))
    owner1Balance = await hardhatToken.BalanceOf(owner1.address);
    let newBalance2 = BigNumber.from(owner1Balance).sub(BigNumber.from(value));
    // console.log(ownerBalance);
    // console.log(owner1Balance);
    // console.log(newBalance);
    // console.log(newBalance2);
    assert(newBalance.eq(newBalance2), "Transfer From Failed!");
  });
});