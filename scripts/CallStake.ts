
   
// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers } = require("hardhat");
const BoredApeNFTHolder = "0x4548d498460599286ce29baf9e6b775c19385227";
const BoredApeTokenAddress = "0x0ed64d01D0B4B655E410EF1441dD677B695639E7";
const BoredApeStakeAddress = " 0xe7f1725E7734CE288F8367e1Bb143E90bb3F0512";

async function main() {
  await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [BoredApeNFTHolder],
  });
  const BoredAppSigner = await await ethers.provider.getSigner(
    BoredApeNFTHolder
  );
  //   console.log(BoredAppSigner);
  const BoredApeStake = await ethers.getContractAt(
    "BoredApeStake",
    BoredApeStakeAddress,
    BoredAppSigner
  );
  console.log(BoredApeStake.address);
  const BoredApeContract = await ethers.getContractAt(
    "IERC721",
    "0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D"
  );
  const BoredApeTokenContract = await ethers.getContractAt(
    "IERC20",
    BoredApeTokenAddress
  );
  //   const balance = await BoredApeContract.balanceOf(
  //     "0x5c93b5ef5d9497bd35437089f52623d1fca22647"
  //   );
  console.log(await BoredApeTokenContract.balanceOf(BoredApeNFTHolder));
  console.log(await BoredApeContract.balanceOf(BoredApeNFTHolder));
  const present = Math.floor(new Date().getTime() / 1000);
  console.log(present);
  console.log(ethers.utils.parseUnits("1", 18));
  console.log(BoredApeTokenAddress);
  const results = await BoredApeStake.Stake(
    ethers.utils.parseUnits("1", 18),
    present
  );
  console.log(results);
  const events = await results.wait();
  console.log(events);
  const resultsWithdraw = await BoredApeStake.WithDrawStake(present);
  const eventsWithdraw = await resultsWithdraw.wait();
  console.log(eventsWithdraw);
  console.log(await BoredApeTokenContract.balanceOf(BoredApeNFTHolder));
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });