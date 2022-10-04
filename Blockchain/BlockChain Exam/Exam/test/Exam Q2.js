const { expect, assert } = require("chai");
const { BigNumber } = require("ethers");
const { mnemonicToEntropy } = require("ethers/lib/utils");

describe("Exam Q2", function () {
  it("Test out all the functions of the contract", async function () {
    const [owner, owner1, owner2] = await ethers.getSigners();
    const Token = await ethers.getContractFactory("ExamQ2");
    const hardhatToken = await Token.deploy("EQN", "Eqan", 1000);

    // Testing Changeable Max Supply
    let newMaxSupply = 10000;
    await hardhatToken.SetMaxTokenSupply(newMaxSupply);   
    let actualMaxSupply = await hardhatToken.GetMaxTokenSupply(newMaxSupply);
    expect(newMaxSupply).to.equal(actualMaxSupply);


    // Data URI Testing
    let tokenId = 1;
    let dataURI = " 10000000";
    await hardhatToken.Mint(tokenId, dataURI);
    let actualDataURI = await hardhatToken.GetNFTDataURI();
    expect(dataURI).to.equal(actualDataURI);

    dataURI = "Somethingelse"
    actualDataURI = await hardhatToken.SetNFTDataURI(tokenId, dataURI);
    expect(dataURI).to.equal(actualDataURI);

    // This will fail as it is changing again
    dataURI = "Somethingelse2"
    actualDataURI = await hardhatToken.SetNFTDataURI(tokenId, dataURI);
    expect(dataURI).to.equal(actualDataURI);
  });
});