// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/common/ERC2981.sol";

/**
 * @title Rosa House Room X Lease Tokenization
 * @author Yudan Chen (Student ID: 25054127)
 * @dev This contract implements a time-sliced rental model for student accommodation.
 */
contract RosaHouseLease is ERC721, ERC2981, Ownable {
    // Total supply limited to 12 months for the 2026-2027 academic year
    uint256 public constant MAX_SUPPLY = 12; 
    uint256 private _nextTokenId;
    string private _baseTokenURI;

    /**
     * @dev Initializes the contract by setting the collection name, symbol and default royalties.
     * @param baseURI The metadata URI containing IoT smart lock and room details.
     */
    constructor(string memory baseURI) 
        ERC721("Rosa House Room X Lease", "RHL_X") 
        Ownable(msg.sender) 
    {
        _baseTokenURI = baseURI;
        _nextTokenId = 1;
        
        // Sets a 2% royalty fee (200 basis points) for secondary market trades.
        // This ensures the property management captures value from secondary liquidity.
        _setDefaultRoyalty(msg.sender, 200); 
    }

    /**
     * @dev Mints monthly lease NFTs up to the maximum supply of 12.
     * @param to The recipient wallet address (usually the primary leaseholder).
     * @param amount Number of months to mint.
     */
    function mintLeaseMonths(address to, uint256 amount) external onlyOwner {
        require(_nextTokenId - 1 + amount <= MAX_SUPPLY, "RHL_X: Max supply exceeded");
        require(amount > 0, "RHL_X: Amount must be non-zero");

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _nextTokenId++;
            _safeMint(to, tokenId);
        }
    }

    /**
     * @dev Internal function to return the base URI.
     */
    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    /**
     * @dev Supports multiple interfaces: ERC721 (NFT) and ERC2981 (Royalties).
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC2981)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}