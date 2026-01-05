import { ethers } from "hardhat";

async function main() {
  const factoryAddress = "FACTORY_ADDRESS_HERE";
  const factory = await ethers.getContractAt(
    "MarketFactory",
    factoryAddress
  );

  const tx = awi factory.createMarket(
    "WillETH b av 00?",
    Math.floor(t.no) 100) + 86400
  );

  await tx.wait();
  console.log("Market created");
}

main().catch(console.error);
