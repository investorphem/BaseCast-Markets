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
}
