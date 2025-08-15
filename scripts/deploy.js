const hre = require("hardhat");
const { upgrades } = require("hardhat");
const fs = require('fs');
require("dotenv").config();
async function main() {

const create = await hre.ethers.deployContract(
  "BookManager",
  [
    "0x3dAc9a6d949Df2Ae4789A2cBBf025F3f0e4A7224",
    "0x3dAc9a6d949Df2Ae4789A2cBBf025F3f0e4A7224",
    "n",
    "n",
    "n",
    "n"
  ],
  {
    libraries: {
      Book: "0x2449B9bBcEf478DB4DFbd700bd7ff6d144EFe6e4"
    }
  }
);

console.log(create.target); // ethers v6: .target thay vì .address


//   const create = await hre.ethers.deployContract("Book");
//   console.log(create.target);

  
  





}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});

