from brownie import SinglPageFinalArtwork, SinglePageRandomPack, SinglePagePacks, accounts


# brownie run scripts/deploy.py --network polygon-test
def main():
    deployer = accounts.load('b8')
    final_artwork = deployer.deploy(SinglPageFinalArtwork,
                                    publish_source=True,
                                    )
    stickerpack = deployer.deploy(SinglePageRandomPack,
                                  publish_source=True,
                                  )
    single_page = deployer.deploy(SinglePagePacks,
                                  stickerpack,
                                  final_artwork,
                                  publish_source=True,
                                  )
    stickerpack.transferOwnership(single_page, {'from': deployer})
    final_artwork.transferOwnership(single_page, {'from': deployer})
    single_page.grantRole("0x00", "0x1215991085d541A586F0e1968355A36E58C9b2b4", {'from': deployer})
