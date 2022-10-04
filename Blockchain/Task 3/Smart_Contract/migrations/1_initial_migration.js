const Migrations = artifacts.require("./Migrations.sol");

module.exports = (deployer) => {
  // 18 is the most common number of decimal places, the same as in the case of ether that is 10^18 wei.
  deployer.deploy(Migrations, "Bitcoin", "BTC", 18, 21000000);
};