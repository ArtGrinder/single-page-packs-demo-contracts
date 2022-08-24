// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/access/Ownable.sol";
import "../interfaces/ISinglePageRandomPack.sol";

/**
    @title Random pack NFT
    @notice that's what users purchase and keep before they can unbox it to get random puzzle pieces
    @author Gene A. Tsvigun
    @dev contains ownership and pack size
  */
contract SinglePageRandomPack is ISinglePageRandomPack, ERC721Enumerable, Ownable {
    uint8 constant public MAX_PACK_SIZE = 10;
    uint8 constant public PIECES_NUM = 14;
    uint256 public nextPackId;

    mapping(PackSize => uint8) public piecesInPackSize;
    mapping(TokenId => PackSize) public size;
    mapping(TokenId => uint8[MAX_PACK_SIZE]) public pieces;

    constructor() ERC721("SinglePage RandomBits Stickerpack NFT", "SRP") {//TODO names
        piecesInPackSize[PackSize.Mini] = 2;
        piecesInPackSize[PackSize.Regular] = 3;
        piecesInPackSize[PackSize.DoubleStuf] = 5;
    }

    function mint(address to, PackSize packSize, uint8[MAX_PACK_SIZE] calldata pieces_) external onlyOwner returns (TokenId tokenId){
        TokenId id = TokenId.wrap(nextPackId);
        _mint(to, TokenId.unwrap(id));
        size[id] = packSize;
        pieces[id] = pieces_;
        nextPackId++;
        return id;
    }

    function burn(TokenId tokenId) external onlyOwner {
        _burn(TokenId.unwrap(tokenId));
        delete size[tokenId];
        delete pieces[tokenId];
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        return "ar://UYgFgiI85-TGeVlWZx-94Q7nExaXHw3UJE9v3qMiu44";
    }

    function piecesNumberInPack(TokenId tokenId) external view returns (uint8){
        return piecesInPackSize[size[tokenId]];
    }

    function piecesInPack(TokenId tokenId) external view returns (uint8[10] memory){
        return pieces[tokenId];
    }

    function hasPieces(address player) external view returns (bool[PIECES_NUM] memory piecesPresent) {
        return hasPieces_(player);
    }

    function hasAllPieces(address player) external view returns (bool) {
        bool[PIECES_NUM] memory piecePresent = hasPieces_(player);
        for (uint8 p = 0; p < PIECES_NUM; p++) {
            if (!piecePresent[p]) {
                return false;
            }
        }
        return true;
    }


    function hasPieces_(address player) private view returns (bool[PIECES_NUM] memory piecesPresent) {
        for (uint8 i = 0; i < balanceOf(player); i++) {
            TokenId pack = TokenId.wrap(tokenOfOwnerByIndex(player, i));
            for (uint8 p = 0; p < pieces[pack].length; p++) {
                if (pieces[pack][p] > 0) {
                    piecesPresent[pieces[pack][p] - 1] = true;
                }
            }
        }
    }
}
