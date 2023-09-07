const { Provider, Account, constants, json, CallData } = require("starknet");
const fs = require("fs");
require('dotenv').config();

const PRIVATE_KEY = process.env.PRIVATE_KEY_TEST || "";
const ACCOUNT = process.env.ACCOUNT_TEST || "";

async function main() {
    const provider = new Provider({ sequencer: { network: constants.NetworkName.SN_GOERLI } }) // for testnet 1
    const account0 = new Account(provider, ACCOUNT, PRIVATE_KEY);

    // Declare & deploy contract
    const compiledSierra = json.parse(fs.readFileSync( "./target/dev/min_nft_market_MockERC20.sierra.json").toString( "ascii"));
    const compiledCasm = json.parse(fs.readFileSync( "./target/dev/min_nft_market_MockERC20.casm.json").toString( "ascii"));
    const deployResponse = await account0.declareAndDeploy({ contract: compiledSierra, casm: compiledCasm, });

    console.log('✅ deployResponse:', deployResponse);
    console.log('✅ Router class hash:', deployResponse.declare.class_hash);
    console.log('✅ Router contract address:', deployResponse.deploy.contract_address);

    // const result = await provider.waitForTransaction( deployResponse.transaction_hash);
    // console.log('✅ result:', result);
}

main().then(() => process.exit(0)).catch(error => {
    console.error(error);
    process.exit(1);
})