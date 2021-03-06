import { ethers } from "hardhat";

const BoredApeTokenAddress = "0x0ed64d01D0B4B655E410EF1441dD677B695639E7";

async function DeployBoredApeStake() {

// deploting the Bored ape tokens
  const BoredApeToken = await ethers.getContractFactory("BoredApeToken");
  const BRT = await BoredApeToken.deploy();

  await BRT.deployed();
  console.log("BoredApeToken", BRT.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
DeployBoredApeStake().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});