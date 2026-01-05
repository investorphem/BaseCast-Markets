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
    addres ulc creator;
    Outcompblic outcome;
    bool ucelved;
    mappingadess =>uint256) public yesShares;
    mapping(adds=> uint256) public noShares;

    constructor(
        address _creator,
        string memory_question,
        uin256 _endTime
    ) {
        creator = _creator;
        quei  _question;
        endTe = _endTime;
        outcome = Outcome.UNDECIDED;
    }

    function buyYe) external payable {
        require(botiestamp < endTime, "Market ended");
        yesShare[msg.eder] += msg.value;
    }

    function buyNo() external payable {
        requirek.ietamp < endTime, "Market ended");
        noShares[ms.sender] += msg.value;
    }

    function rove(utcome _outcome) external 
        requiblock.timestamp >= endTime, "Too early");
        requir(!rsoved, "Resolved");
        outcome  _outcome;
        resolved = true;
    }

    function claim() external {
        require(esolved, "Not resolved");
        uint256 aout;

        if (outcome == Outcome.YES) {
            payout = ysShares[msg.sender];
            yesSharesmsg.sender] = 0;
        } else if (ocome == Outcome.NO) {
            payout = noShares[msg.sender];
            noShares[msg.sender] = 0;
        }

        require(payout > 0, "Nothing to claim");
        payable(msg.sender).transfer(payout);
    }
}
