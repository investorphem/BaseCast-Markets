// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract PredictionMarket {
    enum Outcome {
        UNDECIDED,
        YES,
        NO
    }

    string public question;
    uint256 public endTime;
    address public creator;

    Outcome public outcome;
    bool public resolved;

    mapping(address => uint256) public yesShares;
    mapping(address => uint256) public noShares;

    // Bulk operations tracking
    uint256 public constant MAX_BULK_BUYS = 10;
    uint256 public constant MAX_BULK_CLAIMS = 15;

    event BulkSharesPurchased(
        address indexed buyer,
        bool isYes,
        uint256 totalAmount,
        uint256 totalShares
    );

    event BulkClaimsProcessed(
        address indexed claimer,
        uint256 totalPayout
    );

    constructor(
        address _creator,
        string memory _question,
        uint256 _endTime
    ) {
        creator = _creator;
        question = _question;
        endTime = _endTime;
        outcome = Outcome.UNDECIDED;
    }

    function buyYes() external payable {
        require(block.timestamp < endTime, "Market ended");
        yesShares[msg.sender] += msg.value;
    }

    function buyNo() external payable {
        require(block.timestamp < endTime, "Market ended");
        noShares[msg.sender] += msg.value;
    }

    function resolve(Outcome _outcome) external {
        require(block.timestamp >= endTime, "Too early");
        require(!resolved, "Resolved");
        outcome = _outcome;
        resolved = true;
    }

    function claim() external {
        require(resolved, "Not resolved");
        uint256 payout;

        if (outcome == Outcome.YES) {
            payout = yesShares[msg.sender];
            yesShares[msg.sender] = 0;
        } else if (outcome == Outcome.NO) {
            payout = noShares[msg.sender];
            noShares[msg.sender] = 0;
        }

        require(payout > 0, "Nothing to claim");
        payable(msg.sender).transfer(payout);
    }

    /*//////////////////////////////////////////////////////////////
                           BULK OPERATIONS
    //////////////////////////////////////////////////////////////*/

    /// @notice Bulk purchase YES shares in multiple markets
    /// @param amounts Array of ETH amounts to buy YES shares with (up to 10 purchases)
    function bulkBuyYes(uint256[] calldata amounts) external payable {
        uint256 totalPurchases = amounts.length;
        require(totalPurchases > 0 && totalPurchases <= MAX_BULK_BUYS, "Invalid bulk buy count");
        require(block.timestamp < endTime, "Market ended");

        uint256 totalAmount = 0;
        uint256 totalShares = 0;

        for (uint256 i = 0; i < totalPurchases; i++) {
            require(amounts[i] > 0, "Zero amount");
            yesShares[msg.sender] += amounts[i];
            totalAmount += amounts[i];
            totalShares += amounts[i];
        }

        require(msg.value == totalAmount, "Incorrect total payment");

        emit BulkSharesPurchased(msg.sender, true, totalAmount, totalShares);
    }

    /// @notice Bulk purchase NO shares in multiple markets
    /// @param amounts Array of ETH amounts to buy NO shares with (up to 10 purchases)
    function bulkBuyNo(uint256[] calldata amounts) external payable {
        uint256 totalPurchases = amounts.length;
        require(totalPurchases > 0 && totalPurchases <= MAX_BULK_BUYS, "Invalid bulk buy count");
        require(block.timestamp < endTime, "Market ended");

        uint256 totalAmount = 0;
        uint256 totalShares = 0;

        for (uint256 i = 0; i < totalPurchases; i++) {
            require(amounts[i] > 0, "Zero amount");
            noShares[msg.sender] += amounts[i];
            totalAmount += amounts[i];
            totalShares += amounts[i];
        }

        require(msg.value == totalAmount, "Incorrect total payment");

        emit BulkSharesPurchased(msg.sender, false, totalAmount, totalShares);
    }

    /// @notice Bulk purchase mixed YES/NO shares
    /// @param purchases Array of purchase data (up to 10 purchases)
    struct BulkPurchase {
        bool isYes;
        uint256 amount;
    }

    function bulkBuyMixed(BulkPurchase[] calldata purchases) external payable {
        uint256 totalPurchases = purchases.length;
        require(totalPurchases > 0 && totalPurchases <= MAX_BULK_BUYS, "Invalid bulk buy count");
        require(block.timestamp < endTime, "Market ended");

        uint256 totalAmount = 0;
        uint256 totalYesShares = 0;
        uint256 totalNoShares = 0;

        for (uint256 i = 0; i < totalPurchases; i++) {
            BulkPurchase calldata purchase = purchases[i];
            require(purchase.amount > 0, "Zero amount");

            if (purchase.isYes) {
                yesShares[msg.sender] += purchase.amount;
                totalYesShares += purchase.amount;
            } else {
                noShares[msg.sender] += purchase.amount;
                totalNoShares += purchase.amount;
            }

            totalAmount += purchase.amount;
        }

        require(msg.value == totalAmount, "Incorrect total payment");

        // Emit separate events for YES and NO purchases
        if (totalYesShares > 0) {
            emit BulkSharesPurchased(msg.sender, true, totalYesShares, totalYesShares);
        }
        if (totalNoShares > 0) {
            emit BulkSharesPurchased(msg.sender, false, totalNoShares, totalNoShares);
        }
    }

    /// @notice Bulk claim payouts from multiple resolved markets
    /// @dev This function would be called on multiple market contracts
    /// @param claimAmounts Array of claim amounts to process (up to 15 claims)
    function bulkClaim(uint256[] calldata claimAmounts) external {
        require(resolved, "Market not resolved");
        uint256 totalClaims = claimAmounts.length;
        require(totalClaims > 0 && totalClaims <= MAX_BULK_CLAIMS, "Invalid bulk claim count");

        uint256 totalPayout = 0;

        for (uint256 i = 0; i < totalClaims; i++) {
            uint256 claimAmount = claimAmounts[i];
            require(claimAmount > 0, "Zero claim amount");

            uint256 availablePayout = 0;

            if (outcome == Outcome.YES) {
                require(yesShares[msg.sender] >= claimAmount, "Insufficient YES shares");
                availablePayout = claimAmount;
                yesShares[msg.sender] -= claimAmount;
            } else if (outcome == Outcome.NO) {
                require(noShares[msg.sender] >= claimAmount, "Insufficient NO shares");
                availablePayout = claimAmount;
                noShares[msg.sender] -= claimAmount;
            }

            require(availablePayout > 0, "No payout available");
            totalPayout += availablePayout;
        }

        require(totalPayout > 0, "Nothing to claim");

        // Transfer total payout
        payable(msg.sender).transfer(totalPayout);

        emit BulkClaimsProcessed(msg.sender, totalPayout);
    }

    /// @notice Get bulk operation limits
    /// @return maxBulkBuys Maximum bulk purchases per transaction
    /// @return maxBulkClaims Maximum bulk claims per transaction
    function getBulkLimits() external pure returns (uint256 maxBulkBuys, uint256 maxBulkClaims) {
        return (MAX_BULK_BUYS, MAX_BULK_CLAIMS);
    }

    /// @notice Estimate gas for bulk operations
    /// @param operationCount Number of operations
    /// @param operationType 0=buy, 1=claim
    /// @return estimatedGas Approximate gas cost
    function estimateBulkGas(uint256 operationCount, uint256 operationType)
        external
        pure
        returns (uint256 estimatedGas)
    {
        require(operationCount > 0, "Invalid count");

        uint256 baseGas = 21000;
        uint256 perOperationGas;

        if (operationType == 0) {
            // Buy operations
            perOperationGas = operationCount <= MAX_BULK_BUYS ? 45000 : 55000;
            require(operationCount <= MAX_BULK_BUYS, "Too many buys");
        } else if (operationType == 1) {
            // Claim operations
            perOperationGas = 35000;
            require(operationCount <= MAX_BULK_CLAIMS, "Too many claims");
        } else {
            revert("Invalid operation type");
        }

        return baseGas + (perOperationGas * operationCount);
    }

    /// @notice Get user's total shares and potential payout
    /// @param user User address to check
    /// @return yesSharesOwned YES shares owned
    /// @return noSharesOwned NO shares owned
    /// @return potentialPayout Potential payout if market resolves
    function getUserPosition(address user)
        external
        view
        returns (uint256 yesSharesOwned, uint256 noSharesOwned, uint256 potentialPayout)
    {
        yesSharesOwned = yesShares[user];
        noSharesOwned = noShares[user];

        if (resolved) {
            if (outcome == Outcome.YES) {
                potentialPayout = yesSharesOwned;
            } else if (outcome == Outcome.NO) {
                potentialPayout = noSharesOwned;
            }
        } else {
            // If not resolved, show total investment
            potentialPayout = yesSharesOwned + noSharesOwned;
        }
    }

    /// @notice Get market statistics
    /// @return totalYesVolume Total YES shares purchased
    /// @return totalNoVolume Total NO shares purchased
    /// @return totalParticipants Total unique participants
    /// @return timeRemaining Seconds until market ends (0 if ended)
    function getMarketStats()
        external
        view
        returns (uint256 totalYesVolume, uint256 totalNoVolume, uint256 totalParticipants, uint256 timeRemaining)
    {
        // Note: In a real implementation, you'd track total volumes and participants
        // For this demo, we'll return placeholder values
        totalYesVolume = 0; // Would need to track this
        totalNoVolume = 0;  // Would need to track this
        totalParticipants = 0; // Would need to track this

        if (block.timestamp < endTime) {
            timeRemaining = endTime - block.timestamp;
        } else {
            timeRemaining = 0;
        }
    }
}
