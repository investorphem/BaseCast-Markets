// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PredictionMarket.sol";

contract PredictionMarketBulkTest is Test {
    PredictionMarket market;
    address creator = address(0x123);
    address user1 = address(0x456);
    address user2 = address(0x789);
    address user3 = address(0xABC);

    uint256 marketEndTime;

    function setUp() public {
        marketEndTime = block.timestamp + 1 days;
        market = new PredictionMarket(creator, "Will ETH reach $5000?", marketEndTime);

        // Fund users
        vm.deal(user1, 10 ether);
        vm.deal(user2, 10 ether);
        vm.deal(user3, 10 ether);
    }

    /*//////////////////////////////////////////////////////////////
                           BULK BUY YES TESTS
    //////////////////////////////////////////////////////////////*/

    function testBulkBuyYesSinglePurchase() public {
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, true, 1 ether, 1 ether);
        market.bulkBuyYes{value: 1 ether}(amounts);

        assertEq(market.yesShares(user1), 1 ether);
    }

    function testBulkBuyYesMultiplePurchases() public {
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 0.5 ether;
        amounts[1] = 1 ether;
        amounts[2] = 0.75 ether;

        uint256 totalAmount = 2.25 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, true, totalAmount, totalAmount);
        market.bulkBuyYes{value: totalAmount}(amounts);

        assertEq(market.yesShares(user1), totalAmount);
    }

    function testBulkBuyYesMaximumPurchases() public {
        uint256[] memory amounts = new uint256[](10); // MAX_BULK_BUYS
        for (uint256 i = 0; i < 10; i++) {
            amounts[i] = 0.1 ether;
        }

        uint256 totalAmount = 1 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, true, totalAmount, totalAmount);
        market.bulkBuyYes{value: totalAmount}(amounts);

        assertEq(market.yesShares(user1), totalAmount);
    }

    function testBulkBuyYesExceedsMaximum() public {
        uint256[] memory amounts = new uint256[](11); // Exceeds MAX_BULK_BUYS
        for (uint256 i = 0; i < 11; i++) {
            amounts[i] = 0.1 ether;
        }

        vm.prank(user1);
        vm.expectRevert("Invalid bulk buy count");
        market.bulkBuyYes{value: 1.1 ether}(amounts);
    }

    function testBulkBuyYesAfterMarketEnd() public {
        // Fast forward to after market end
        vm.warp(marketEndTime + 1);

        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        vm.prank(user1);
        vm.expectRevert("Market ended");
        market.bulkBuyYes{value: 1 ether}(amounts);
    }

    function testBulkBuyYesIncorrectPayment() public {
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 0.5 ether;
        amounts[1] = 1 ether;
        uint256 totalAmount = 1.5 ether;

        vm.prank(user1);
        vm.expectRevert("Incorrect total payment");
        market.bulkBuyYes{value: 1 ether}(amounts); // Sending less than required
    }

    function testBulkBuyYesZeroAmount() public {
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 0; // Zero amount

        vm.prank(user1);
        vm.expectRevert("Zero amount");
        market.bulkBuyYes{value: 0}(amounts);
    }

    /*//////////////////////////////////////////////////////////////
                           BULK BUY NO TESTS
    //////////////////////////////////////////////////////////////*/

    function testBulkBuyNoSinglePurchase() public {
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 1 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, false, 1 ether, 1 ether);
        market.bulkBuyNo{value: 1 ether}(amounts);

        assertEq(market.noShares(user1), 1 ether);
    }

    function testBulkBuyNoMultiplePurchases() public {
        uint256[] memory amounts = new uint256[](3);
        amounts[0] = 0.5 ether;
        amounts[1] = 1 ether;
        amounts[2] = 0.75 ether;

        uint256 totalAmount = 2.25 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, false, totalAmount, totalAmount);
        market.bulkBuyNo{value: totalAmount}(amounts);

        assertEq(market.noShares(user1), totalAmount);
    }

    /*//////////////////////////////////////////////////////////////
                           BULK BUY MIXED TESTS
    //////////////////////////////////////////////////////////////*/

    function testBulkBuyMixedYesAndNo() public {
        PredictionMarket.BulkPurchase[] memory purchases = new PredictionMarket.BulkPurchase[](4);
        purchases[0] = PredictionMarket.BulkPurchase({isYes: true, amount: 0.5 ether});
        purchases[1] = PredictionMarket.BulkPurchase({isYes: false, amount: 1 ether});
        purchases[2] = PredictionMarket.BulkPurchase({isYes: true, amount: 0.75 ether});
        purchases[3] = PredictionMarket.BulkPurchase({isYes: false, amount: 0.25 ether});

        uint256 totalAmount = 2.5 ether;

        vm.prank(user1);
        market.bulkBuyMixed{value: totalAmount}(purchases);

        assertEq(market.yesShares(user1), 1.25 ether); // 0.5 + 0.75
        assertEq(market.noShares(user1), 1.25 ether);  // 1 + 0.25
    }

    function testBulkBuyMixedOnlyYes() public {
        PredictionMarket.BulkPurchase[] memory purchases = new PredictionMarket.BulkPurchase[](2);
        purchases[0] = PredictionMarket.BulkPurchase({isYes: true, amount: 0.5 ether});
        purchases[1] = PredictionMarket.BulkPurchase({isYes: true, amount: 1 ether});

        uint256 totalAmount = 1.5 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkSharesPurchased(user1, true, totalAmount, totalAmount);
        market.bulkBuyMixed{value: totalAmount}(purchases);

        assertEq(market.yesShares(user1), totalAmount);
        assertEq(market.noShares(user1), 0);
    }

    /*//////////////////////////////////////////////////////////////
                           BULK CLAIM TESTS
    //////////////////////////////////////////////////////////////*/

    function testBulkClaimYesOutcome() public {
        // First, buy YES shares
        vm.prank(user1);
        market.buyYes{value: 2 ether}();

        // Resolve market as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        // Bulk claim
        uint256[] memory claimAmounts = new uint256[](2);
        claimAmounts[0] = 1 ether;
        claimAmounts[1] = 0.5 ether;

        uint256 expectedPayout = 1.5 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkClaimsProcessed(user1, expectedPayout);
        market.bulkClaim(claimAmounts);

        assertEq(market.yesShares(user1), 0.5 ether); // 2 - 1.5
    }

    function testBulkClaimNoOutcome() public {
        // First, buy NO shares
        vm.prank(user1);
        market.buyNo{value: 3 ether}();

        // Resolve market as NO
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.NO);

        // Bulk claim
        uint256[] memory claimAmounts = new uint256[](2);
        claimAmounts[0] = 1 ether;
        claimAmounts[1] = 1.5 ether;

        uint256 expectedPayout = 2.5 ether;

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkClaimsProcessed(user1, expectedPayout);
        market.bulkClaim(claimAmounts);

        assertEq(market.noShares(user1), 0.5 ether); // 3 - 2.5
    }

    function testBulkClaimMaximumClaims() public {
        // Buy many YES shares
        vm.startPrank(user1);
        for (uint256 i = 0; i < 15; i++) {
            market.buyYes{value: 0.1 ether}();
        }
        vm.stopPrank();

        // Resolve as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        // Bulk claim maximum
        uint256[] memory claimAmounts = new uint256[](15);
        for (uint256 i = 0; i < 15; i++) {
            claimAmounts[i] = 0.1 ether;
        }

        vm.prank(user1);
        vm.expectEmit(true, false, false, true);
        emit PredictionMarket.BulkClaimsProcessed(user1, 1.5 ether);
        market.bulkClaim(claimAmounts);
    }

    function testBulkClaimExceedsMaximum() public {
        // Buy YES shares
        vm.prank(user1);
        market.buyYes{value: 2 ether}();

        // Resolve as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        // Try to claim more than maximum
        uint256[] memory claimAmounts = new uint256[](16);
        for (uint256 i = 0; i < 16; i++) {
            claimAmounts[i] = 0.1 ether;
        }

        vm.prank(user1);
        vm.expectRevert("Invalid bulk claim count");
        market.bulkClaim(claimAmounts);
    }

    function testBulkClaimUnresolvedMarket() public {
        // Buy YES shares but don't resolve market
        vm.prank(user1);
        market.buyYes{value: 1 ether}();

        uint256[] memory claimAmounts = new uint256[](1);
        claimAmounts[0] = 1 ether;

        vm.prank(user1);
        vm.expectRevert("Market not resolved");
        market.bulkClaim(claimAmounts);
    }

    function testBulkClaimInsufficientShares() public {
        // Buy 1 ether YES shares
        vm.prank(user1);
        market.buyYes{value: 1 ether}();

        // Resolve as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        // Try to claim more than owned
        uint256[] memory claimAmounts = new uint256[](2);
        claimAmounts[0] = 1 ether;
        claimAmounts[1] = 1 ether; // This will exceed balance

        vm.prank(user1);
        vm.expectRevert("Insufficient YES shares");
        market.bulkClaim(claimAmounts);
    }

    /*//////////////////////////////////////////////////////////////
                           UTILITY FUNCTION TESTS
    //////////////////////////////////////////////////////////////*/

    function testGetBulkLimits() public {
        (uint256 maxBuys, uint256 maxClaims) = market.getBulkLimits();
        assertEq(maxBuys, 10);
        assertEq(maxClaims, 15);
    }

    function testEstimateBulkGas() public {
        // Test buy operations gas estimation
        uint256 buyGas = market.estimateBulkGas(5, 0);
        assertEq(buyGas, 21000 + (45000 * 5)); // 243000

        // Test claim operations gas estimation
        uint256 claimGas = market.estimateBulkGas(8, 1);
        assertEq(claimGas, 21000 + (35000 * 8)); // 301000
    }

    function testEstimateBulkGasInvalidType() public {
        vm.expectRevert("Invalid operation type");
        market.estimateBulkGas(5, 99);
    }

    function testEstimateBulkGasExceedsLimits() public {
        vm.expectRevert("Too many buys");
        market.estimateBulkGas(11, 0);

        vm.expectRevert("Too many claims");
        market.estimateBulkGas(16, 1);
    }

    function testGetUserPositionUnresolved() public {
        // Buy some shares
        vm.prank(user1);
        market.buyYes{value: 1 ether}();

        vm.prank(user1);
        market.buyNo{value: 0.5 ether}();

        (uint256 yesShares, uint256 noShares, uint256 potentialPayout) = market.getUserPosition(user1);

        assertEq(yesShares, 1 ether);
        assertEq(noShares, 0.5 ether);
        assertEq(potentialPayout, 1.5 ether); // Total investment when unresolved
    }

    function testGetUserPositionResolvedYes() public {
        // Buy shares
        vm.prank(user1);
        market.buyYes{value: 2 ether}();

        vm.prank(user1);
        market.buyNo{value: 1 ether}();

        // Resolve as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        (uint256 yesShares, uint256 noShares, uint256 potentialPayout) = market.getUserPosition(user1);

        assertEq(yesShares, 2 ether);
        assertEq(noShares, 1 ether);
        assertEq(potentialPayout, 2 ether); // YES payout
    }

    function testGetMarketStats() public {
        (uint256 totalYesVolume, uint256 totalNoVolume, uint256 totalParticipants, uint256 timeRemaining) =
            market.getMarketStats();

        // These are placeholder values in the current implementation
        assertEq(totalYesVolume, 0);
        assertEq(totalNoVolume, 0);
        assertEq(totalParticipants, 0);
        assertGt(timeRemaining, 0); // Should be positive before market ends
    }

    /*//////////////////////////////////////////////////////////////
                           INTEGRATION TESTS
    //////////////////////////////////////////////////////////////*/

    function testBulkOperationsWorkflow() public {
        // 1. Bulk buy YES shares
        vm.prank(user1);
        uint256[] memory yesAmounts = new uint256[](2);
        yesAmounts[0] = 1 ether;
        yesAmounts[1] = 0.5 ether;
        market.bulkBuyYes{value: 1.5 ether}(yesAmounts);

        // 2. Bulk buy NO shares
        vm.prank(user2);
        uint256[] memory noAmounts = new uint256[](1);
        noAmounts[0] = 2 ether;
        market.bulkBuyNo{value: 2 ether}(noAmounts);

        // 3. Bulk buy mixed shares
        vm.prank(user3);
        PredictionMarket.BulkPurchase[] memory mixedPurchases = new PredictionMarket.BulkPurchase[](2);
        mixedPurchases[0] = PredictionMarket.BulkPurchase({isYes: true, amount: 0.75 ether});
        mixedPurchases[1] = PredictionMarket.BulkPurchase({isYes: false, amount: 1.25 ether});
        market.bulkBuyMixed{value: 2 ether}(mixedPurchases);

        // Verify positions
        (uint256 user1Yes,,) = market.getUserPosition(user1);
        (uint256 user2No,,) = market.getUserPosition(user2);
        (uint256 user3Yes, uint256 user3No,) = market.getUserPosition(user3);

        assertEq(user1Yes, 1.5 ether);
        assertEq(user2No, 2 ether);
        assertEq(user3Yes, 0.75 ether);
        assertEq(user3No, 1.25 ether);

        // 4. Resolve market as YES
        vm.warp(marketEndTime + 1);
        market.resolve(PredictionMarket.Outcome.YES);

        // 5. Bulk claims
        vm.prank(user1);
        uint256[] memory user1Claims = new uint256[](2);
        user1Claims[0] = 1 ether;
        user1Claims[1] = 0.25 ether;
        market.bulkClaim(user1Claims);

        vm.prank(user3);
        uint256[] memory user3Claims = new uint256[](1);
        user3Claims[0] = 0.75 ether;
        market.bulkClaim(user3Claims);

        // Verify final positions
        (uint256 finalUser1Yes,,) = market.getUserPosition(user1);
        (uint256 finalUser3Yes,,) = market.getUserPosition(user3);

        assertEq(finalUser1Yes, 0.25 ether); // 1.5 - 1.25
        assertEq(finalUser3Yes, 0); // Fully claimed
    }

    function testBulkOperationsGasEfficiency() public {
        // Measure gas for individual buys
        uint256 gasStart = gasleft();

        vm.startPrank(user1);
        market.buyYes{value: 0.1 ether}();
        market.buyYes{value: 0.1 ether}();
        market.buyYes{value: 0.1 ether}();
        vm.stopPrank();

        uint256 individualGas = gasStart - gasleft();

        // Measure gas for bulk buy
        gasStart = gasleft();

        uint256[] memory bulkAmounts = new uint256[](3);
        bulkAmounts[0] = 0.1 ether;
        bulkAmounts[1] = 0.1 ether;
        bulkAmounts[2] = 0.1 ether;

        vm.prank(user1);
        market.bulkBuyYes{value: 0.3 ether}(bulkAmounts);

        uint256 bulkGas = gasStart - gasleft();

        // Bulk should be more gas efficient
        assertLt(bulkGas, individualGas);
    }

    function testBulkOperationsErrorHandling() public {
        // Test that one failed operation doesn't prevent validation
        uint256[] memory amounts = new uint256[](1);
        amounts[0] = 0;

        vm.prank(user1);
        vm.expectRevert("Zero amount");
        market.bulkBuyYes{value: 0}(amounts);

        // Verify no shares were purchased
        assertEq(market.yesShares(user1), 0);
    }
}
