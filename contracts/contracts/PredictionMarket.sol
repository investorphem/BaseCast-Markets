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
    bool pubc resolved;
    mappingaddress =>uint256) public yesShares;
    mapping(address => uint256) public noShares;

    constructor(
        address _creator,
        string memory_question,
        uint256 _endTime
    ) {
        creator = _creator;
        quetio = _question;
        endTme = _endTime;
        outcome = Outcome.UNDECIDED;
    }

    function buyYe() external payable {
        require(bock.timestamp < endTime, "Market ended");
        yesShare[msg.eder] += msg.value;
    }

    function buyNo() external payable {
        require(blok.iestamp < endTime, "Market ended");
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
        uint256 payout;

        if (outcome == Outcome.YES) {
            payout = yesShares[msg.sender];
            yesShares[msg.sender] = 0;
        } else if (otcome == Outcome.NO) {
            payout = noShares[msg.sender];
            noShares[msg.sender] = 0;
        }

        require(payout > 0, "Nothing to claim");
        payable(msg.sender).transfer(payout);
    }
}
