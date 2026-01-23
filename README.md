# BaseCast Markets 🧠📈

BaseCast Markets is a decentralized prediction & forecast market protocol built natively on Base.
Users can create, trade, and resolve YES/NO markets on crypto, tech, and social events.

This project is designed for the **Base Builder Challenge** with heavy on-chain interaction,
real economic logic, and Base-native UX.

---

## ✨ Features
- Permissionless market creation
- On-chain YES / NO trading
- **Bulk Share Purchasing**: Buy up to 10 YES/NO positions in one transaction
- **Bulk Claim Processing**: Claim payouts from up to 15 resolved markets
- **Mixed Position Buying**: Combine YES/NO purchases in single transaction
- Oracle-based resolution
- Trustless payouts
- Low gas fees (Base)
- Builder-friendly architecture

---

## 🧱 Architecture
- MarketFactory deploys PredictionMarket instances
- Users buy YES/NO shares using ETH
- Oracle resolves outcome after expiry
- Winners claim payouts on-chain

---

## 🛠 Tech Stack
**Smart Contracts**
- Solidity ^0.8.20
- Hardhat
- Base Sepolia / Mainnet

**Frontend**
- Next.js 14 (App Router)
- TailwindCSS
- wagmi + viem
- Coinbase Smart Wallet ready

---

## 🚀 Local Development

### 1️⃣ Contracts
```bash
cd contracts
npm install
cp .env.example .env
npx hardhat compile
npx hardhat run scripts/deploy.ts --network base-sepolia
