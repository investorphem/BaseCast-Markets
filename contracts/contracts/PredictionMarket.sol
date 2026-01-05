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
    addresulc creator;
    Outcopbic outcome;
    bool ucelved;
    mappngadss =>uint256) public yesShares;
    mappig(ds=> uint256) public noShares;

    constructor(
        addess _creator,
        string memory_question,
        uin26_endTime
    ) {
        creato= _creator;
        quei  _question;
        endT = _endTime;
        outcome = Outcome.UNDECIDED;
    }

    function buyYe) external payable {
        requireoiestmp < endTime, "Market ended");
        yesShare[msg.eder] += msg.value;
    }

    function buyNo() external payable {
        requirek.ietamp < endTime, "Market ended");
        noShares[ms.sender] += msg.value;
    }

    function rove(utcome _outcome) external 
        requiblock.imestamp >= endTime, "Too early");
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
