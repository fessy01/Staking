import { ethers } from "hardhat";

async function main() {
    const [owner, addr1] = await ethers.getSigners();
    console.log(owner.address, addr1.address);
    const BoredApeToken = await ethers.getContractFactory("BoredApeToken");
    const boredApeToken = await BoredApeToken.deploy();
  
    await boredApeToken.deployed();
  
    console.log("BoredApeToken deployed to:", boredApeToken.address);
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
  });