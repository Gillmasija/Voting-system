// deploy.js
require('dotenv').config(); // Load environment variables from .env file
const contract = require('./Voting.json');
const kit = require('@celo/contractkit');

// Function to deploy the smart contract
async function deployContract() {
    try {
        // Initialize Celo ContractKit
        const kitInstance = kit.newKit(process.env.CELO_NETWORK_URL);
        kitInstance.addAccount(process.env.PRIVATE_KEY);

        // Get the deployer's account
        const accounts = await kitInstance.web3.eth.getAccounts();
        const deployer = accounts[0];

        // Create a new instance of the smart contract
        const instance = new kitInstance.web3.eth.Contract(contract.abi);
        const deploy = instance.deploy({ data: contract.bytecode });

        // Deploy the contract to the Celo blockchain
        const newContract = await deploy.send({
            from: deployer,
            gas: 5000000,
        });

        console.log('Contract deployed at:', newContract.options.address);
    } catch (error) {
        console.error('Error deploying contract:', error);
    }
}

deployContract();
