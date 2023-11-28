
# Building a Decentralized Voting Application with Celo Blockchain

## Table of Contents

1. [Introduction](#introduction)
2. [Getting Started](#getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
3. [Smart Contract (Voting.sol)](#smart-contract-votingsol)
    - [Overview](#overview)
    - [Security Considerations](#security-considerations)
4. [Frontend Application (app.js)](#frontend-application-appjs)
    - [Overview](#overview)
    - [Testing Strategies](#testing-strategies)
5. [Contributing](#contributing)
    - [How to Contribute](#how-to-contribute)
    - [Local Development](#local-development)
6. [License](#license)
## Introduction

Blockchain technology has the potential to revolutionize the way we vote. By using blockchain, we can create voting systems that are more transparent, secure, and accessible. This tutorial will guide you through the process of building a decentralized voting application on the Celo blockchain.


## Purpose:
This tutorial aims to guide developers in creating a decentralized voting application using the Celo blockchain. By the end of this tutorial, you'll have a solid understanding of Celo's blockchain technology and be able to build a simple but functional decentralized voting system. This project showcases the power of blockchain in ensuring transparency and security in voting processes.

## **Introduction:**
Blockchain technology, at its core, is a decentralized and distributed ledger system that enables secure and transparent record-keeping. One blockchain platform that stands out for its emphasis on usability, stability, and the goal of financial inclusion is Celo.

### **Celo Blockchain Technology:**
Celo is an open-source blockchain platform that aims to make financial tools accessible to anyone with a mobile phone. Built on the Ethereum framework, Celo extends its capabilities by introducing features like a stablecoin pegged to the US Dollar, allowing for a more user-friendly and stable environment. The platform prioritizes ease of use, making it an ideal choice for projects seeking to integrate blockchain technology seamlessly.

### **Applicability to the Topic:**
Celo's blockchain technology is particularly well-suited for our decentralized voting application. Its focus on usability ensures that individuals with basic technical knowledge can easily participate in the voting process, promoting inclusivity. Additionally, Celo's stability features, such as its stablecoin, contribute to a more reliable ecosystem, crucial for applications where accuracy and trust are paramount, as in the case of voting systems.

By leveraging Celo for our decentralized voting application, we tap into a blockchain platform that aligns with the principles of transparency, security, and accessibility. As we proceed with this tutorial, we'll explore how to harness the capabilities of Celo to build a robust and user-friendly decentralized voting system.

## **Prerequisites:**
- Basic understanding of blockchain concepts. If you are new to blockchain, consider exploring resources such as [Blockchain Basics](https://www.ibm.com/cloud/learn/blockchain-basics) to gain a foundational understanding.
- Familiarity with JavaScript and Node.js. If you need a refresher or are new to these technologies, check out Mozilla Developer Network's [JavaScript Guide](https://developer.mozilla.org/en-US/docs/Web/JavaScript/Guide) and the [Node.js Getting Started Guide](https://nodejs.org/en/docs/guides/getting-started-guide/).
- Celo Development Kit (Celo SDK) installed. Follow the tutorial on [Installing Celo Development Kit](https://docs.celo.org/developer-guide/start) to set up the necessary tools for Celo blockchain development.

### Installation

1. Clone the repository: `git clone https://github.com/Gillmasija/Voting-system.git`
2. Install dependencies: `npm install`
3. Set up the Celo Development Kit by following [this tutorial](https://docs.celo.org/developer-guide/start).


# Step 1: Setting Up the Project:
Begin by creating a new Node.js project and installing the necessary dependencies. Use the following commands in your terminal:
```bash
mkdir decentralized-voting
cd decentralized-voting
npm init -y
npm install celo-sdk
```

# Step 2: Smart Contract Development:
Create a simple smart contract for the voting system. The contract should include functions for creating a new election, submitting votes, and retrieving results. Here's a basic example:
```Solidity
pragma solidity ^0.5.16;

contract Voting {
    // Struct to represent a candidate
    struct Candidate {
        uint256 id;
        string name;
        uint256 voteCount;
    }

    // Array to store candidate information
    Candidate[] public candidates;

    // Mapping to track voter addresses and their vote status
    mapping(address => bool) public hasVoted;

    // Event to be emitted when a new election is initiated
    event ElectionInitiated();

    // Event to be emitted when a vote is cast
    event VoteCast(address indexed voter, uint256 candidateId);

    /**
     * @dev Initiates a new election.
     * Emits ElectionInitiated event.
     * Developers should customize the logic inside this function
     * based on their election initiation requirements.
     */
    function initiateElection() public {
        // TODO: Add logic to initiate a new election
        emit ElectionInitiated();
    }

    /**
     * @dev Allows voters to cast their votes for a candidate.
     * @param _candidateId The ID of the candidate to vote for.
     * Developers should ensure proper validation and security measures
     * to prevent unauthorized voting.
     */
    function castVote(uint256 _candidateId) public {
        // Ensure the candidate ID is within valid range
        require(_candidateId < candidates.length, "Invalid candidate ID");
        
        // Ensure the voter has not already cast a vote
        require(!hasVoted[msg.sender], "You have already voted");

        // Update candidate vote count
        candidates[_candidateId].voteCount++;

        // Mark voter as having voted
        hasVoted[msg.sender] = true;

        // Emit the VoteCast event
        emit VoteCast(msg.sender, _candidateId);
    }
}

```
## Security Considerations

When developing and deploying smart contracts, it's crucial to prioritize security to mitigate potential vulnerabilities and protect users' assets. Here are some key security considerations for developers working with the `Voting.sol` smart contract:

### 1. Ensure Secure Coding Practices

Developers should follow secure coding practices to minimize vulnerabilities. Common pitfalls such as reentrancy, integer overflow, and unchecked external calls can be mitigated with thorough code reviews, testing, and adherence to best practices.

### 2. Handle Private Keys Responsibly

Private keys are sensitive and should never be exposed or shared. Developers are strongly encouraged to manage private keys securely, using hardware wallets or secure key management solutions. Avoid hardcoding private keys in the codebase or configuration files.

### 3. Be Cautious with External Calls

External calls to other contracts or external actors can introduce security risks. Developers should thoroughly test and validate external calls, applying the "Checks-Effects-Interactions" pattern to minimize potential vulnerabilities.

### 4. Validate Inputs and Permissions

Always validate inputs and permissions to prevent unauthorized access or manipulation of the smart contract. Use modifiers and require statements to enforce access controls and validate parameters before executing critical operations.

### 5. Be Mindful of Gas Limitations

Consider the gas costs associated with smart contract functions, especially when dealing with loops and complex operations. Gas limitations can impact the usability and efficiency of the decentralized application, so developers should optimize code for gas efficiency.

These considerations serve as guidelines to enhance the security of your decentralized application. Regular code audits, testing, and staying informed about the latest developments in smart contract security are essential practices for maintaining a secure and robust system.

Remember, security is an ongoing process, and developers should stay vigilant to address emerging threats and vulnerabilities.


# Step 3: Deploying the Smart Contract:
Use Celo's development network for testing purposes. Deploy the smart contract using the following script:
```Javascript
// deploy.js
const contract = require('./Voting.json'); // Make sure to compile your smart contract first
const kit = require('@celo/contractkit');

// Function to deploy the smart contract
async function deployContract() {
    // Initialize Celo ContractKit
    const kitInstance = await kit.newKit('https://alfajores-forno.celo-testnet.org');
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
}

deployContract();
```
**Getting Started:**

Before deploying the smart contract, make sure you have a Celo account and its private key. If you're new to Celo or need assistance, follow these steps to create a Celo account and ensure the security of your private key:

1. **Create a Celo Account:**
   - Visit the [Celo Wallet](https://celowallet.app/) to create a new Celo account. Follow the on-screen instructions to set up your wallet.

2. **Secure Your Private Key:**
   - Your private key is a sensitive piece of information. Ensure you securely store and backup your private key. Consider using hardware wallets or secure key management practices.

3. **Tutorial: Creating a Celo Account and Securing Private Key:**
   - For a detailed walkthrough, check out the [tutorial on creating a Celo account and securing your private key](https://docs.celo.org/celo-owner-guide/overview). This tutorial provides step-by-step guidance for a secure setup.

4. **Provide Private Key for Deployment:**
   - Once you have your Celo account and private key, export the private key and use it during the deployment process. For example:
      ```bash
      export PRIVATE_KEY=your_private_key
      node deploy.js
      ```

Ensure you keep your private key secure and never share it publicly.

For further assistance or troubleshooting, refer to the [Celo documentation](https://docs.celo.org/).


Run the deployment script using:
```bash
export PRIVATE_KEY=your_private_key
node deploy.js
```
The provided code is a set of commands that you can run in a Bash shell to deploy the smart contract using the `deploy.js` script. Here's an explanation of each part:

1. `export PRIVATE_KEY=your_private_key`: This command exports a private key as an environment variable named `PRIVATE_KEY`. You need to replace `your_private_key` with the actual private key associated with the Celo account that will be used to deploy the smart contract.

2. `node deploy.js`: This command runs the `deploy.js` script using Node.js. The script is responsible for deploying the smart contract to the Celo blockchain.

### Troubleshooting: "Cannot find module" Error

If you encounter an error similar to the one below:

![Cannot find module error](![Alt text](image.png))

**Solution:**

This error typically occurs when the specified module or file is not found. Follow these steps to resolve it:

1. **Check File Paths:**
   - Verify that the file specified in the error message (`./Voting.json` in this case) exists in the correct location.

2. **Correct File Paths in Code:**
   - Double-check your code, specifically the paths where you are requiring or importing modules. Ensure that they match the actual file paths.

3. **Ensure File Existence:**
   - Confirm that the file `Voting.json` is present in the expected directory.

If the issue persists, consider [checking our tutorial on resolving common Node.js module errors](https://www.freecodecamp.org/news/error-cannot-find-module-node-npm-error-solved/) for further guidance.


After running the provided code, you can expect to see the contract address logged to the console. Here's an example result you might see after running deploy.js:
```bash
Contract deployed at: 0x1234567890123456789012345678901234567890
```
The actual address will be different, but it will be similar in structure. This address is where your smart contract is deployed on the Celo blockchain. You can use this address to interact with your smart contract from your frontend application.

# Step 4: Building the Frontend - Developing a Simple Web Interface:

Now that we have our smart contract deployed on the Celo blockchain, let's create a user-friendly web interface to interact with it. For simplicity, we'll use HTML, CSS, and JavaScript. You can enhance the frontend further based on your project requirements.
##Create HTML file (index.html):
```html
    <!-- index.html -->
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Decentralized Voting App</title>
</head>
<body>
    <h1>Decentralized Voting App</h1>

    <button onclick="startElection()">Start New Election</button>

    <label for="electionId">Election ID:</label>
    <input type="number" id="electionId" placeholder="Enter Election ID">
    <button onclick="vote()">Vote</button>

    <button onclick="getResult()">Get Result</button>

    <div id="result"></div>

    <script src="app.js"></script>
</body>
</html>
```
## Create JavaScript file (app.js):
```javascript
// app.js
const kit = require('@celo/contractkit');
const contract = require('./Voting.json'); // Adjust path accordingly

// Set up ContractKit
const kitInstance = kit.newKit('https://alfajores-forno.celo-testnet.org');
kitInstance.addAccount(process.env.PRIVATE_KEY);

// Get the deployed contract instance
const contractInstance = new kitInstance.web3.eth.Contract(contract.abi, '0x1234567890123456789012345678901234567890'); // Replace with your contract address

// Function to start a new election
async function startElection() {
    try {
        const transaction = await contractInstance.methods.startElection(1).send();
        console.log('Transaction Hash:', transaction.transactionHash);
    } catch (error) {
        console.error('Error:', error);
    }
}

// Function to submit a vote
async function vote() {
    const electionId = document.getElementById('electionId').value;
    try {
        const transaction = await contractInstance.methods.vote(electionId).send();
        console.log('Transaction Hash:', transaction.transactionHash);
    } catch (error) {
        console.error('Error:', error);
    }
}

// Function to get the result of an election
async function getResult() {
    const electionId = document.getElementById('electionId').value;
    try {
        const result = await contractInstance.methods.getResult(electionId).call();
        document.getElementById('result').innerText = `Result: ${result}`;
    } catch (error) {
        console.error('Error:', error);
    }

    // Assume there is a function to cast a vote
function castVote(candidateId) {
    // Your logic to cast a vote...

    // Display success message to the user
    console.log("Vote cast successfully!");
}

// Example of improved error handling
try {
    // Attempt to initiate a new election
    initiateElection();
} catch (error) {
    // Handle errors by displaying meaningful messages to the user
    console.error("Failed to initiate election:", error.message);
}

try {
    // Attempt to cast a vote
    castVote(1); // Pass the candidate ID as an example
} catch (error) {
    // Handle errors by displaying meaningful messages to the user
    console.error("Failed to cast vote:", error.message);
}

}
```
## Link to a Tutorial on Creating a Web Interface for a Smart Contract:

To learn more about creating a web interface for a smart contract, you can follow the tutorial here. This tutorial provides step-by-step guidance on building a simple decentralized application frontend using web technologies and Web3.js.

By integrating this frontend with your Celo smart contract, users can easily interact with the voting system through a web browser, making the application more accessible and user-friendly.

Remember to replace placeholder values such as the contract address and private key with your actual values before testing your application.



# **Step 5: Testing the Application - Hosting and Connecting the Frontend:**

Now that we've built the frontend, it's time to host it on a web server and connect it to the deployed smart contract on the Celo blockchain. This step is crucial to allow users to interact with the voting system through a user-friendly interface.

1. **Host the Frontend:**
    - There are various ways to host a simple web application. One common approach is to use GitHub Pages if your repository is hosted on GitHub.
    - Create a new branch in your repository named `gh-pages`.
    - Push your `index.html` and `app.js` files to this branch.
    - After a few moments, you should be able to access your hosted application at `https://your-username.github.io/your-repo-name`.

2. **Connect the Frontend to the Smart Contract:**
    - Open your `app.js` file and locate the line where the contract address is specified. Replace `'0x1234567890123456789012345678901234567890'` with the actual address of your deployed smart contract.

3. **Test the Application:**
    - Open the hosted application in a web browser.
    - Use the provided buttons to start a new election, submit votes, and retrieve results.
    - Check the browser's console for transaction hashes and potential errors. The JavaScript console can be accessed in most browsers by right-clicking on the page, selecting "Inspect," and navigating to the "Console" tab.

4. **Enhancements (Optional):**
    - Depending on your project requirements, you can enhance the frontend further. For example, you may add user authentication, real-time result updates, or a more visually appealing design.

5. **Demo and Share:**
    - Share the hosted application link with others to test the decentralized voting system. Provide clear instructions on how users can simulate the voting process and observe the results.

**Link to a Tutorial on Hosting Web Applications:**

To learn more about hosting web applications, you can follow the tutorial [here](https://pages.github.com/). This guide will walk you through the process of using GitHub Pages to host your HTML, CSS, and JavaScript files directly from your GitHub repository.

By completing this step, you demonstrate the full cycle of a decentralized voting application – from interacting with a smart contract on the blockchain to providing a user-friendly interface accessible via a web browser.

Remember to replace placeholder values in your code, such as the contract address, with actual values before testing your application.

## Testing Strategies

Ensuring the reliability and security of your decentralized application involves comprehensive testing. Here are strategies for testing both the smart contract and the frontend application:

### Smart Contract Testing

#### 1. Unit Testing

- **Purpose:** Test individual functions and components of the smart contract in isolation.
- **Tools:** Use testing frameworks like Truffle or Hardhat to write and execute unit tests.
- **Considerations:** Cover edge cases, validate input constraints, and simulate various scenarios.

#### 2. Integration Testing

- **Purpose:** Test the interactions and interoperability of different components within the smart contract.
- **Tools:** Leverage testing frameworks to create integration tests that simulate the behavior of the entire smart contract.
- **Considerations:** Verify that different functions work together as expected and validate state changes.

#### 3. Security Audits

- **Purpose:** Conduct security audits to identify and address potential vulnerabilities.
- **Tools:** Engage external security firms or use automated analysis tools to perform security audits.
- **Considerations:** Regularly update dependencies, follow best practices, and stay informed about security issues.

### Frontend Application Testing

#### 1. Unit Testing

- **Purpose:** Verify the functionality of individual components in the frontend application.
- **Tools:** Use testing libraries such as Jest or Mocha for writing and running unit tests.
- **Considerations:** Test user interface components, functions, and interactions with the smart contract.

#### 2. Integration Testing

- **Purpose:** Test the interactions between different components in the frontend application.
- **Tools:** Implement integration tests to validate the flow and communication between various parts of the application.
- **Considerations:** Verify that user actions trigger the expected changes and updates.

#### 3. User Experience Testing

- **Purpose:** Evaluate the overall user experience and usability of the frontend application.
- **Tools:** Conduct manual testing and consider using automated testing tools for UI/UX testing.
- **Considerations:** Test the application on various devices and browsers to ensure a consistent and user-friendly experience.

### Testing on Celo Testnet

Before deploying your decentralized application on the Celo mainnet, it's highly recommended to thoroughly test on the Celo testnet. Testing on the testnet allows you to identify and address potential issues before they impact real users and assets. Follow these steps:

1. Deploy your smart contract and frontend on the Celo testnet.
2. Execute a variety of test scenarios to ensure the correct behavior of your application.
3. Monitor gas costs and optimize your code for efficiency.
4. Perform security audits and address any vulnerabilities identified during testing.

By adopting a comprehensive testing strategy and thoroughly testing on the Celo testnet, you can significantly enhance the reliability and security of your decentralized application.

Remember, testing is an iterative process, and ongoing testing and monitoring are essential to maintaining a robust and secure application.


# Conclusion:
Congratulations! You've successfully built a decentralized voting application on the Celo blockchain. This project demonstrates the potential of blockchain in ensuring trust and transparency in voting systems. Feel free to expand on this project by adding features such as user authentication, real-time result updates, and more.

# Code Repository:
Check out the code in the [Voting-system](https://github.com/Gillmasija/voting-system).

## License

This project is licensed under the [MIT License](LICENSE). You can find a copy of the license in the [LICENSE](LICENSE) file.










