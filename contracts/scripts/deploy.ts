import { ethers } from "hardhat";

async function main() {
  const Factory = await ethers.getContractFactory("MarketFactory");
  const factory = await Factory.deploy();
  await factory.waitForDeployment();

  console.log("MarketFactory deployed to:", await factory.getAddress());
}

main().catch(console.error);
