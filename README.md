# BaseCast Markets 🧠📈

BaseCast Markets is a decentralized prediction market protocol built natively on Base.
Users can create and trade prediction markets on real-world and crypto-native events.

---

## 🚀 Features
- Permissionless market creation
- On-chain YES / NO trading
- Oracle-resolved outcomes
- Trustless payouts
- Low-fee Base transactions

---

## 🧱 Smart Contracts
- MarketFactory.sol – creates markets
- PredictionMarket.sol – handles trading and settlement

---

## ⚙️ Tech Stack
- Solidity + Hardhat
- Base Mainnet / Sepolia
- Next.js 14
- TailwindCSS
- OnchainKit
- Coinbase Smart Wallet

---

## 🧪 Local Development

### Contracts
```bash
cd contracts
npm install
npx hardhat compile
npx hardhat node
npx hardhat run scripts/deploy.ts --network base-sepolia
