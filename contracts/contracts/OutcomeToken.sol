// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract OutcomeToken is ERC1155 {
    constructor() ERC1155("") {}
}
