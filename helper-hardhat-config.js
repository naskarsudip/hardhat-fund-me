const networkConfig = {
  5: {
    name: "Goerli",
    ethUsdPriceFeed: "0xD4a33860578De61DBAbDc8BFdb98FD742fA7028e",
  },

  137: {
    name: "polygon",
    ethUsdPriceFeed: "0x0715A7794a1dc8e42615F059dD6e406A6594651A",
  },
};

const developmentChains = ["hardhat", "localHost"];
const DECIMALS = 8;
const INITIAL_ANSWR = 2000000000000;

module.exports = {
  networkConfig,
  developmentChains,
  DECIMALS,
  INITIAL_ANSWR,
};
