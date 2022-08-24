import pytest
from brownie import interface, reverts


@pytest.fixture
def final_artwork(SinglePageFinalArtwork, dev):
    return dev.deploy(SinglePageFinalArtwork)


@pytest.fixture
def stickerpack_contract(SinglePageRandomPack, dev):
    return dev.deploy(SinglePageRandomPack)


@pytest.fixture
def stickerpack(stickerpack_contract, dev):
    return interface.ISinglePageRandomPack(stickerpack_contract)


@pytest.fixture
def single_page(SinglePagePacks, stickerpack_contract, final_artwork, dev):
    spp = dev.deploy(SinglePagePacks, stickerpack_contract, final_artwork)
    stickerpack_contract.transferOwnership(spp, {"from": dev})
    final_artwork.transferOwnership(spp, {"from": dev})
    return interface.ISinglePagePacks(spp)


def test_grant_pack(single_page, stickerpack, user_a, dev):
    assert stickerpack.balanceOf(user_a) == 0
    single_page.grantPack(
        user_a,
        {"from": dev}
    )
    assert stickerpack.balanceOf(user_a) == 1
    single_page.grantPack(
        user_a,
        {"from": dev}
    )
    assert stickerpack.balanceOf(user_a) == 2


def test_grant_all_pieces(single_page, stickerpack, user_a, dev):
    assert stickerpack.balanceOf(user_a) == 0
    while not all(stickerpack.hasPieces(user_a)):
        assert not stickerpack.hasAllPieces(user_a)
        single_page.grantPack(
            user_a,
            {"from": dev}
        )
    assert stickerpack.hasAllPieces(user_a)


def test_mint(single_page, stickerpack, user_a, dev):
    assert stickerpack.balanceOf(user_a) == 0
    while not stickerpack.hasAllPieces(user_a):
        with reverts():
            single_page.mint({'from': user_a})
        single_page.grantPack(
            user_a,
            {"from": dev}
        )
        print(stickerpack.balanceOf(user_a))
    assert all(stickerpack.hasPieces(user_a))
    assert stickerpack.hasAllPieces(user_a)
    assert stickerpack.balanceOf(user_a) > 0

    tx = single_page.mint({'from': user_a})
    assert stickerpack.balanceOf(user_a) == 0
    assert tx.value == 0
