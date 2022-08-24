// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/access/Ownable.sol";
import "../interfaces/ISinglePageRandomPack.sol";

/**
    @title Final Artwork
    @notice that's what users assemble by unboxing random puzzle pieces
    @author Gene A. Tsvigun
  */
contract SinglePageFinalArtwork is ERC721, Ownable {
    uint256 public nextTokenId;
    string public tokenURI_;

    constructor() ERC721("Flowerbed by @anybront", "FLB") {}

    function mint(address to) external onlyOwner returns (uint256 tokenId) {
        tokenId = nextTokenId;
        _mint(to, tokenId);
        nextTokenId++;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return "ar://vyxbq4ja1E3LKwBKAKh1XvSIh6f8S2npn7cqYT2cxFo";
    }
}
