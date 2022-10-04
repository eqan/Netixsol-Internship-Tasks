const main = async () => {
  const transactionsFactory = await hre.ethers.getContractFactory("Transaction");
  const transactionsContract = await transactionsFactory.deploy(1);
  // const transactionsContract = await transactionsFactory.deploy("Bitcoin", "BTC", 18, 1);

  await transactionsContract.deployed();

  console.log("Transactions address: ", transactionsContract.address);
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain();