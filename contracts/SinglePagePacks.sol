//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.14;

import "@openzeppelin/access/AccessControl.sol";
import "@openzeppelin/token/ERC721/IERC721.sol";
import "@openzeppelin/token/ERC721/utils/ERC721Holder.sol";

import "../interfaces/ISinglePagePacks.sol";
import "./SinglePageRandomPack.sol";


/**
    @title Assemble a single image from puzzle pieces delivered to players in RandomPacks
    @notice TODO
  */
contract SinglePagePacks is ISinglePagePacks, ERC721Holder, AccessControl {
    uint8 constant public MAX_PACK_SIZE = 10;
    uint8 constant public MAX_PACKS_PER_USER = 100;
    uint8 constant public PIECES_NUM = 14;

    ISinglePageRandomPack randomPack;

    constructor(ISinglePageRandomPack randomPack_){
        randomPack = randomPack_;
        _setupRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function grantPack(address player) external onlyRole(DEFAULT_ADMIN_ROLE) {
        uint256[MAX_PACK_SIZE] memory expandedValues;

        uint8 piecesNum = randomPack.piecesInPackSize(PackSize.Regular);

        uint256 sortaRandomness = uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty)));

        uint8[MAX_PACK_SIZE] memory pieces = expand(sortaRandomness, piecesNum, PIECES_NUM);
        TokenId tokenId = randomPack.mint(player, PackSize.Regular, pieces);
        emit Pack(tokenId, pieces);
    }

    function mint() external {
        //TODO
    }


    function expand(uint256 randomValue, uint8 piecesNum, uint8 modulo) internal pure returns (uint8[MAX_PACK_SIZE] memory) {
        uint8[MAX_PACK_SIZE] memory expandedValues;
        for (uint256 i = 0; i < piecesNum; i++) {
            expandedValues[i] = uint8(uint256(keccak256(abi.encode(randomValue, i))) % modulo);
        }
        return expandedValues;
    }

}