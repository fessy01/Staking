import { ethers } from "hardhat";

async function main() {
    const BoredApeToken = await ethers.getContractFactory("BoredApeToken");
  const boredApeToken = await BoredApeToken.deploy("BoredApeToken" , "BRT");

  await boredApeToken.deployed();

  console.log("Greeter deployed to:", boredApeToken.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });