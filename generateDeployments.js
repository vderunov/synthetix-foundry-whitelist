const fs = require('fs').promises;
const path = require('path');
const ethers = require("ethers");

const USAGE = [
    'Examples:',
    '  - OP Sepolia (Testnet)',
    `      node ${path.basename(__filename)} 11155420`,
    '  - Local Anvil fork',
    `      node ${path.basename(__filename)} 31337`,
].join('\n');

function err(message) {
    throw new Error(
        [
            message,
            '---------------------------------------------',
            USAGE,
            '---------------------------------------------',
        ].join('\n')
    );
}

const [chainId = err('Missing argument "chainId"')] = process.argv.slice(2);

async function readJSON(filePath) {
    return JSON.parse(await fs.readFile(filePath, 'utf8'));
}

async function writeJSON(filePath, data) {
    await fs.writeFile(filePath, JSON.stringify(data, null, 2), 'utf8');
}

function readableAbi(abi) {
    return new ethers.Interface(abi).format();
}

async function getAddressForDeployment() {
    const deploymentData = await readJSON(path.join(__dirname, 'deployment.json'));
    return deploymentData[chainId]['Whitelist'];
}

async function processFiles() {
    await fs.mkdir(`deployments/${chainId}/`, {recursive: true})
    const data = await readJSON(path.join(__dirname, '/out/Whitelist.sol/Whitelist.json'));
    const address = await getAddressForDeployment();
    const abi = readableAbi(data.abi);

    await writeJSON(`deployments/${chainId}/Whitelist.abi.json`, data.abi);
    await writeJSON(`deployments/${chainId}/Whitelist.meta.json`, {
        compiler: data.metadata.compiler,
        settings: {
            optimizer: data.metadata.settings.optimizer,
            evmVersion: data.metadata.settings.evmVersion
        }
    });
    await writeJSON(`deployments/${chainId}/Whitelist.methods.json`, data.methodIdentifiers);
    await writeJSON(`deployments/${chainId}/Whitelist.readable-abi.json`, abi);
    await writeJSON(`deployments/${chainId}/Whitelist.address.json`, address);
    await fs.writeFile(`deployments/${chainId}/Whitelist.js`, `module.exports.address = "${address}";`, 'utf8');
    await fs.appendFile(`deployments/${chainId}/Whitelist.js`, `\nmodule.exports.abi = ${JSON.stringify(abi, null, 2)};`, 'utf8');
}

processFiles().catch(console.error);