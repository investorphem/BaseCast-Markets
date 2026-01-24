export interface Market {
  id: string;
  question: string;
  creator: string;
  expiry: number;
  outcome?: boolean;
  resolved: boolean;
  yesShares: number;
  noShares: number;
  totalLiquidity: string;
}

export interface Position {
  marketId: string;
  yesAmount: number;
  noAmount: number;
}
