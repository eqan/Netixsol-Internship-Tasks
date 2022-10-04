require('@nomiclabs/hardhat-waffle');

module.exports = {
  solidity: '0.8.0',
  networks: {
    ropsten: {
      url: 'https://eth-ropsten.alchemyapi.io/v2/1-ceryD_8BuBoj7o8Ygciy3G5Czl8n50',
      accounts: ['9406eb97ace8d76d7958a310051ecf9989f56f568c05012fa0b376add952e84b'],
    },
  },
};