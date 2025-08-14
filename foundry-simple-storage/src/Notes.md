Compile project - forge compile

Deploy a contract to anvil using forge - `forge create <Contract_Name> --interactive`
Deploy a contract to any rpc using forge - `forge create <Contract_Name> --rpc-url <rpc_url> --interactive`

What is an rpc url?
An RPC URL is basically the address of a node. Whoever runs that node is the one answering your MetaMask (or Foundry) requests

More efficient way, write a script to do it in a consistent reproducible way. Foundry has functions to help with this in solidity.
script has .s.sol just as a convention

forge-std is the foundry standard library

Run the script using forge script DeploySimpleStorage.s.sol
If we dont specify the broadcast, forge will spin up a temporary chain to deploy the contract as a simulation.

//private key is dummy here :)
//Actual command
`forge script DeploySimpleStorage --rpc-url http://127.0.0.1:8545 --broadcast --private-key 0xac0974bec39a17e36ba4a6b4d238ff944bacb478cbed5efcae784d7bf4f2ff80`


Once we run above we get a folder broadcast/ which contains metadata about our transaction (In simple terms, a transaction captures details of an activity that has taken place on a blockchain.)
The nonce in the transaction icrements everytime we send a txn, so it basically counts your transactions.
So you could replay your transaction if needed by sending the same txn data with the same nonce.
It serves as a counter to ensure sequential processing and prevent duplication from a specific sender?
Contract deployment is a type of transaction

cast has command to convert between different radixes
`cast --to-base 0xE dec `= 14



note - `source .env` will add env variables in the bash terminal, echo $PRIVATE_KEY

So the earlier deployment could be done - forge script DeploySimpleStorage --rpc-url $LOCAL_RPC_URL --broadcast --private-key $PRIVATE_KEY


Instead of using a .env file, for our private key we could use the wallet in cast which stores them in an encrypted form
`cast wallet import <Alias/Account_name>  --interactive`

Trigger script using - 
//Sender is the account associated with that private key
`forge script script/DeploySimpleStorage.s.sol --rpc-url $LOCAL_RPC_URL --account defaultKey --sender 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266 --broadcast -vvvv`
`forge script script/DeploySimpleStorage.s.sol --rpc-url $LOCAL_RPC_URL --account defaultKey --sender $DEFAULT_ACCOUNT --broadcast -vvvv --password $LOCAL_PASSWORD`

Keystore location - .foundry/keystores/
List keystores - cast wallet list


Interact with deployed contract (Similar to function call buttons in remix)
We can use cast to interact with contracts and eth nodes

When we deployed the contract earlier we got the contract address - 0x5FbDB2315678afecb367f032d93F642f64180aa3

We now want to send a transaction to the contract to trigger a specific function

`cast send <Contract_Address> <Function_Signature> <Arguements_to_be_passed_to_function>`

`cast send 0x5FbDB2315678afecb367f032d93F642f64180aa3 "store(uint256)" 123 --rpc-url $LOCAL_RPC_URL --account defaultKey --from $DEFAULT_ACCOUNT --password $LOCAL_PASSWORD`

Now if we just want to call a function in the contract i.e. not sending any data just triggering a function we can use cast call

`cast call <Contract_Address> <Function_Signature>`

`cast call 0x5FbDB2315678afecb367f032d93F642f64180aa3 "retrieve()"` -> returned 0x000000000000000000000000000000000000000000000000000000000000007c = 124


Now lets try deploying our contract to a testnet (Sepolia)
We imported our metamask wallet `cast wallet import MetaMask --interactive` (0x5Cd9142693Ad5CE14033262cb90833ADd71c6580)

Metamask uses an infura node (the rpc in metamask) for sepolia, which we cant use since its only for them, so we need our own node to use

We can use alchemy to deploy a sepolia node - https://dashboard.alchemy.com/apps/e7zkugq8wywkf3qj/metrics

//Kept same password for metamask account
`forge script script/DeploySimpleStorage.s.sol --rpc-url $ALCHEMY_SEPOLIA_RPC_URL --account MetaMask --sender $METAMASK_ACCOUNT --broadcast --password $LOCAL_PASSWORD -vvvv `

Deployed at - 0x5698bDD274748c03B4a011fCD8162c2D44eD8255
Creation transaction - https://sepolia.etherscan.io/tx/0xd388a427f1da7e8ded57279e13b0e92b38fe678202b33eaafa5691c0ff4e087e
Contract details - https://sepolia.etherscan.io/address/0x5698bDD274748c03B4a011fCD8162c2D44eD8255

The folder broadcast/1115511 contains the transactions to sepolia (chain_id)

`cast send 0x5698bDD274748c03B4a011fCD8162c2D44eD8255 "store(uint256)" 123 --rpc-url $ALCHEMY_SEPOLIA_RPC_URL --account MetaMask --from $METAMASK_ACCOUNT --password $LOCAL_PASSWORD`

`cast call 0x5698bDD274748c03B4a011fCD8162c2D44eD8255 "retrieve()" --rpc-url $ALCHEMY_SEPOLIA_RPC_URL --account MetaMask --from $METAMASK_ACCOUNT --broadcast --password $LOCAL_PASSWORD -vvvv `

On calling it returned 0x000000000000000000000000000000000000000000000000000000000000007c, so its working



### Alchemy
Its like AWS for Web3 apps


### ZKSYNC
Changed to ZKSYNC FOUNDRY (fork of foundry) by cloning the repo./foundryup-zksync/install-foundry-zksync and installing it
Now version of `forge --version` gives forge Version: 1.0.0-foundry-zksync-v0.0.24

To revert back to vanilla foundry we can run `foundryup`

and to switch back to zksync-foundry we run `foundryup-zksync`

Every ethereum chain has type 0,1,2 txns. In addition to these L2s might have their own type of txns like ZKSYNC has type 113 (0x71)
Type 2 is the current default type and is primarily associated with the introduction of a base fee and priority fee mechanism aimed at improving gas price predictability, 0 is legacy

One advantage of using L2 rollups like ZKS, is that its much cheaper to deploy using them. The contract we deployed in Sepolia would 
have cost 7$ on the ETH mainnet and actual contracts are a lot larger and bigger.

https://l2fees.info/