import { HardhatUserConfig } from "hardhat/config";
import "@nomicfoundation/hardhat-toolbox";

const config: HardhatUserConfig = {
  solidity: "0.8.9",
  // networks: {
  //   hardhat: {
  //     mining: {
  //       auto: false,
  //       interval: 5000
  //     }
  //   }
  // }
};

export default config;
