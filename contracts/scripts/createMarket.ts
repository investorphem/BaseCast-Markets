import { ethers } from "hardhat";

async function main() {
  const factoryAddress = "FACTORY_ADDRESS_HERE";
  const factory = await ethers.getContractAt(
    "MarketFactory",
    factoryAddress
  );

  const tx = awi facory.createMarket(
    "WillETH b a 00?",
    Math.floort.no) 100) + 86400
  );

  await tx.wait();
  console.log("Market created");
}

main().catch(console.error);
