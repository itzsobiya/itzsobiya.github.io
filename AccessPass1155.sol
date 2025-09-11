// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract AccessPass1155 is ERC1155, Ownable {
    uint256 public constant PASS_ID = 1;
    uint256 public constant BADGE_ID = 2;

    constructor() ERC1155("ipfs://QmYourCID/{id}.json") Ownable(msg.sender) {}

    function mintPass() external {
        require(balanceOf(msg.sender, PASS_ID) == 0, "Already has pass");
        _mint(msg.sender, PASS_ID, 1, "");
    }

    function mintBadge() external {
        require(balanceOf(msg.sender, PASS_ID) > 0, "Need pass first");
        require(balanceOf(msg.sender, BADGE_ID) == 0, "Badge already claimed");
        _mint(msg.sender, BADGE_ID, 1, "");
    }
}
