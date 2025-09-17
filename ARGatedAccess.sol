// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// Import from GitHub (Remix will automatically fetch these)
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.9.3/contracts/utils/Strings.sol";

contract ARGatedAccess is ERC1155, Ownable {
    using Strings for uint256;
    
    
    
    // Token IDs
    uint256 public constant PASS_ID = 0;
    uint256 public constant BADGE_ID = 1;
    
    // Base URI for metadata
    string public baseURI;
    
    // Track claimed badges per wallet to prevent double-claiming
    mapping(address => bool) public hasClaimedBadge;
    
    // Events
    event PassMinted(address indexed recipient);
    event BadgeClaimed(address indexed recipient);
    
    constructor(string memory _baseURI) ERC1155(_baseURI) {
        baseURI = _baseURI;
        // Mint initial supply of passes to contract owner for distribution
        _mint(msg.sender, PASS_ID, 1000, "");
    }
    
    // Mint a free pass (on testnet)
    function mintPass() external {
        require(balanceOf(msg.sender, PASS_ID) == 0, "Already has a pass");
        _mint(msg.sender, PASS_ID, 1, "");
        emit PassMinted(msg.sender);
    }
    
    // Claim a badge (requires pass ownership)
    function claimBadge() external {
        require(balanceOf(msg.sender, PASS_ID) > 0, "Need a pass to claim badge");
        require(!hasClaimedBadge[msg.sender], "Already claimed badge");
        
        hasClaimedBadge[msg.sender] = true;
        _mint(msg.sender, BADGE_ID, 1, "");
        emit BadgeClaimed(msg.sender);
    }
    
    // Override URI function to include proper metadata
    function uri(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(baseURI, tokenId.toString()));
    }
    
    // Update base URI (only owner)
    function setBaseURI(string memory _newBaseURI) external onlyOwner {
        baseURI = _newBaseURI;
    }
    
    // Batch mint passes (for owner to distribute initially)
    function batchMintPasses(address[] calldata recipients) external onlyOwner {
        for (uint256 i = 0; i < recipients.length; i++) {
            _mint(recipients[i], PASS_ID, 1, "");
        }
    }
}