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
```

### 2️⃣ Frontend
```bash
cd frontend
npm install
cp .env.example .env.local
npm run dev
```

---

## 📁 Project Structure

```
BaseCast-Markets/
├── contracts/              # Solidity contracts (Hardhat)
│   ├── contracts/          # Smart contracts
│   ├── scripts/            # Deployment scripts
│   ├── test/               # Contract tests
│   └── hardhat.config.ts   # Hardhat configuration
├── frontend/               # Next.js frontend
│   ├── src/
│   │   ├── app/            # Next.js App Router pages
│   │   ├── components/     # React components
│   │   ├── hooks/          # Custom React hooks
│   │   ├── lib/            # Utility functions
│   │   └── types/          # TypeScript types
│   ├── public/             # Static assets
│   └── package.json
├── docs/                   # Documentation
└── README.md
```

---

## 🎯 Usage

### Creating a Market
1. Connect your wallet
2. Click "Create Market"
3. Enter your question and expiry date
4. Pay the creation fee
5. Market is deployed on-chain

### Trading Shares
1. Browse active markets
2. Choose YES or NO position
3. Enter amount to buy
4. Confirm transaction
5. Receive shares as NFTs

### Claiming Payouts
1. Wait for market resolution
2. If you chose the winning outcome
3. Click "Claim Payout"
4. Receive ETH reward instantly

---

## 🔐 Smart Contracts

### MarketFactory.sol
- Deploys new PredictionMarket contracts
- Tracks all created markets
- Manages creation fees

### PredictionMarket.sol
- Handles YES/NO share trading
- Manages market resolution
- Processes payout claims
- Uses oracles for outcome verification

### Key Features
- **Gas Optimized**: Bulk operations reduce transaction costs
- **Trustless**: All logic on-chain, no admin intervention
- **Oracle Integration**: Automated market resolution
- **NFT Shares**: Tradable share certificates

---

## 🧪 Testing

### Contract Tests
```bash
cd contracts
npx hardhat test
```

### Frontend Tests
```bash
cd frontend
npm test
```

---

## 📊 Deployment

### Base Sepolia (Testnet)
- **MarketFactory**: `0x...`
- **Sample Market**: `0x...`

### Base Mainnet (Production)
- Coming soon after testing phase

---

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Add tests
5. Submit a pull request

---

## 📄 License

MIT License - see LICENSE file for details

---

## ⚠️ Disclaimer

This is experimental software for the Base Builder Challenge.
Use at your own risk. Markets may lose value.
