require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

const RInKEYBY_RPC_URL =
  "https://eth-rinkeby.alchemyapi.io/v2/qHe54-rytGu8yNd0iCKHs175dNHfl3PN";
ETHERSCAN_API_KEY = "KKV1ZT8UYTSDK6H2M3S8ZX586RF6XGY6QE";
PRIVATE_KEY =
  "a1a7b06aeba2ea6fb37c0a76723867cbec5a68e91cc44a0cca2f1eded7fac3b3";

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.9",
  networks: {
    rinkeby: {
      url: RInKEYBY_RPC_URL,
      accounts: [PRIVATE_KEY],
    },
  },
};
