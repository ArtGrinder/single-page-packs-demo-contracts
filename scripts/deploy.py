from brownie import SinglePageRandomPack, SinglePagePacks, accounts


# brownie run scripts/deploy.py --network polygon-test
def main():
    deployer = accounts.load('b8')
    rp = deployer.deploy(SinglePageRandomPack,
                         publish_source=True,
                         )
    spp = deployer.deploy(SinglePagePacks,
                          rp,
                          publish_source=True,
                          )
    rp.transferOwnership(spp, {'from': deployer})
    spp.grantRole("0x00", "0x1215991085d541A586F0e1968355A36E58C9b2b4", {'from': deployer})
