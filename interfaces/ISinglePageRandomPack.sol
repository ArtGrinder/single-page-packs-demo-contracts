// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/token/ERC721/extensions/IERC721Enumerable.sol";

    enum PackSize {Mini, Regular, DoubleStuf}

type TokenId is uint256;
    struct TokenData {
        TokenId id;
        PackSize size;
    }

interface ISinglePageRandomPack is IERC721Enumerable {
    function mint(address to, PackSize packSize, uint8[10] calldata pieces) external returns (TokenId tokenId);

    function burn(TokenId tokenId) external;

    function size(TokenId tokenId) external view returns (PackSize);

    function piecesInPackSize(PackSize packSize) external view returns (uint8);

    function piecesNumberInPack(TokenId tokenId) external view returns (uint8);

    function piecesInPack(TokenId tokenId) external view returns (uint8[10] memory pieces);

    function hasPieces(address player) external view returns (bool[14] memory piecesPresent);

    function hasAllPieces(address player) external view returns (bool);
}
