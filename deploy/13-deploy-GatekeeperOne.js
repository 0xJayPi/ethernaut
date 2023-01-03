const { network } = require("hardhat")
// const { developmentChains } = require("../helper-hardhat-config")
// const { verify}

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy, log } = deployments
    const { deployer } = await getNamedAccounts()

    await deploy("GatekeeperOne", {
        from: deployer,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
    await deploy("HackGatekeeperOne", {
        from: deployer,
        log: true,
        waitConfirmations: network.config.blockConfirmations || 1,
    })
}

module.exports.tags = ["GatekeeperOne"]
