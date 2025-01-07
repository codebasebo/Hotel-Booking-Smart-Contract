require("@nomicfoundation/hardhat-toolbox");

module.exports = {
  solidity: "0.8.20", // Use the correct Solidity version
  networks: {
    localhost: {
      url: "http://127.0.0.1:8545", // Local network
    },
    hardhat: {
      chainId: 1337, // Hardhat network
    },
  },
};