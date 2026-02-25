🚀 How to Run the Project Locally
1. Clone the repository
git clone https://github.com/Nidvitha/carbon-registry.git
cd carbon-registry

2. Install Node.js dependencies
npm install
(Run this in the folder with package.json — usually /backend if you have one.)

3. Install Ganache
Download Ganache: https://trufflesuite.com/ganache/
Install and open Ganache

5. Create & Start a Workspace in Ganache
Click New Workspace → Ethereum
Name the workspace (e.g., CarbonRegistry)
Ensure RPC Server Port is 7545 (http://127.0.0.1:7545)
Click Start

7. Deploy the Smart Contract (Solidity)
Visit Remix IDE (https://remix.ethereum.org)
Copy the CarbonRegistry.sol from /blockchain folder and create the file in remix with name CarbonRegistry.sol and paste it.
Go to Solidity Compiler and expand advanced configuartions and select evm version as "london"
Then click on compile 
Deploy:
Environment: Custom -External HTTP Provider
Below remove the url and paste this http://127.0.0.1:7545
After deployment:
Copy contract address in deploy and run transactions move below and you'll find CarbonRegistry at copy that address  
Copy contract ABI --> click ABI copy button in Solidity compiler tab

9. Update Environment Variables & ABI
Copy .env.example to .env in your backend folder
Paste your contract address in .env:
env
CONTRACT_ADDRESS=0x...your_contract_address
Paste ABI in abi.json file

11. Start Backend Server
bash
node index.js
(Or whatever the entry point file is)

12. Open Frontend
Open owner.html, admin.html, investor.html in your browser (or whatever frontend files you have)
