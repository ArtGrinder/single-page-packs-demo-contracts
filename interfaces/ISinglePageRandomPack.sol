// SPDX-License-Identifier: MIT
pragma solidity ^0.8.14;

import "@openzeppelin/token/ERC721/IERC721.sol";

    enum PackSize {Mini, Regular, DoubleStuf}

type TokenId is uint256;

interface ISinglePageRandomPack is IERC721 {
    function mint(address to, PackSize packSize) external returns (TokenId tokenId);

    function size(TokenId tokenId) external view returns (PackSize);

    function piecesInPackSize(PackSize packSize) external view returns (uint8);

    function piecesInPack(TokenId tokenId) external view returns (uint8);
}
