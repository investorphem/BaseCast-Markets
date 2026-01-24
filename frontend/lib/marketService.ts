import { Market } from './types';

export const getMarkets = async (): Promise<Market[]> => {
  // Mock data - replace with actual API call
  return [
    {
      id: '1',
      question: 'Will ETH reach $5000 by end of 2024?',
      creator: '0x...',
      expiry: Date.now() + 86400000,
      resolved: false,
      yesShares: 100,
      noShares: 50,
      totalLiquidity: '1.5',
    },
  ];
};

export const getMarketById = async (id: string): Promise<Market | null> => {
  const markets = await getMarkets();
  return markets.find(m => m.id === id) || null;
};
