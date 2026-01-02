import { ethers } from "hardhat";

async function main() {
  const factoryAddress = "FACTORY_ADDRESS_HERE";
  const factory = await ethers.getContractAt(
    "MarketFactory",
    factoryAddress
  );

  const tx = await factory.createMarket(
    "Will ETH be above $4000?",
    Math.floor(Date.now() / 1000) + 86400
  );

  await tx.wait();
  console.log("Market created");
}

main().catch(console.error);
