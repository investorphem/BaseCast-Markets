// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./PredictionMarket.sol";

contract MarketFactory {
    address[] public markets;

    event MarketCreated(address market, string question);

    function createMarket(
        string calldata question,
        uint256 endTime
    ) external {
        PredictionMarket market =
            new PredictionMarket(msg.sender, question, endTime);

        markets.push(address(market));
        emit MarketCreated(address(market), question);
    }

    function getMarkets() external view returns (address[] memory) {
        return markets;
    }
}
