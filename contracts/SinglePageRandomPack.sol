// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/token/ERC721/ERC721.sol";
import "@openzeppelin/access/Ownable.sol";
import "../interfaces/ISinglePageRandomPack.sol";

/**
    @title Random pack NFT
    @notice that's what users purchase and keep before they can unbox it to get random puzzle pieces
    @author Gene A. Tsvigun
    @dev contains ownership and pack size
  */
contract SinglePageRandomPack is ISinglePageRandomPack, ERC721, Ownable {
    uint8 constant public MAX_PACK_SIZE = 10;
    uint256 public nextPackId;

    mapping(TokenId => PackSize) public size;
    mapping(PackSize => uint8) public piecesInPackSize;

    constructor() ERC721("SinglePage ArtGrinder RandomPack NFT", "SRP") {//TODO names
        piecesInPackSize[PackSize.Mini] = 3;
        piecesInPackSize[PackSize.Regular] = 7;
        piecesInPackSize[PackSize.DoubleStuf] = 10;
    }

    function mint(address to, PackSize packSize, uint8[10] calldata pieces) external onlyOwner returns (TokenId tokenId){
        TokenId id = TokenId.wrap(nextPackId);
        _mint(to, TokenId.unwrap(id));
        size[id] = packSize;
        nextPackId++;
        return id;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return "https://arweave.net/_fnRKg27Djs4ZG0rgqKU5YpaRdgpeorCKqizcKhdtcw";
    }

    function piecesInPack(TokenId tokenId) external view returns (uint8){
        return piecesInPackSize[size[tokenId]];
    }

}
