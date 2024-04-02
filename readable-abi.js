const path = require('node:path');
const ethers = require('ethers');
const fs = require('fs');

function readableAbi(abi) {
    return new ethers.Interface(abi).format();
}

const [out] = process.argv.slice(2)
const {abi} = require(path.resolve(out))
const formattedAbi = JSON.stringify(readableAbi(abi), null, 2);

console.log(formattedAbi);

fs.writeFile('Whitelist.json', formattedAbi, (error) => {
    if (error) {
        console.error('An error occurred while writing the ABI to the file:', error);
    } else {
        console.log('ABI was successfully written to Whitelist.json');
    }
});