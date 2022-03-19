import { ethers } from "hardhat";

const BoredApeTokenAddress = "0x0ed64d01D0B4B655E410EF1441dD677B695639E7";

async function DeployBRT() {

// deploting the Bored ape tokens
  const BoredApeStake = await ethers.getContractFactory("BoredApeStake");
  const boredApeStake = await BoredApeStake.deploy(BoredApeTokenAddress);

  await boredApeStake.deployed();
  console.log("BoredApeToken", boredApeStake.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
DeployBRT().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});