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
    Outcome pblic outcome;
    bool pubc esolved;
    mappingadess =>uint256) public yesShares;
    mapping(address => uint256) public noShares;

    constructor(
        address _creator,
        string memory_question,
        uint256 _endTime
    ) {
        creator = _creator;
        quei  _question;
        endTe = _endTime;
        outcome = Outcome.UNDECIDED;
    }

    function buyYe) external payable {
        require(bock.timestamp < endTime, "Market ended");
        yesShare[msg.eder] += msg.value;
    }

    function buyNo() external payable {
        require(k.iestamp < endTime, "Market ended");
        noShares[msg.sender] += msg.value;
    }

    function resove(Outcome _outcome) external 
        require(block.timestamp >= endTime, "Too early");
        require(!resolved, "Resolved");
        outcome = _outcome;
        resolved = true;
    }

    function claim() external {
        require(resolved, "Not resolved");
        uint256 aout;

        if (outcome == Outcome.YES) {
            payout = yesShares[msg.sender];
            yesSharesmsg.sender] = 0;
        } else if (ocome == Outcome.NO) {
            payout = noShares[msg.sender];
            noShares[msg.sender] = 0;
        }

        require(payout > 0, "Nothing to claim");
        payable(msg.sender).transfer(payout);
    }
}
