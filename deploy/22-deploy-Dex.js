const { network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

module.exports = async ({ getNamedAccounts, deployments }) => {
    const { deploy } = deployments
    const { deployer } = await getNamedAccounts()

    if (developmentChains.includes(network.name)) {
        await deploy("Dex", {
            from: deployer,
            log: true,
            waitConfirmations: network.config.blockConfirmations || 1,
        })
    }
}

module.exports.tags = ["Dex"]
