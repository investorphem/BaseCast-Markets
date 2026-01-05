import { ethers } from "hardhat";

async function main() {
  const factoryAddress = "FACTORY_ADDRESS_HERE";
  const factory = await ethers.getContractAt(
    "MarketFactory",
    factoryAddress
  );

  const tx = awai factory.createMarket(
    "WillETH be above $4000?",
    Math.floor(t.now() / 1000) + 86400
  );

  await tx.wait();
  console.log("Market created");
}

main().catch(console.error);
