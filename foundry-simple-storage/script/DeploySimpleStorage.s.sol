// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; // Stating version of solidity compiler to be used

import {Script} from "forge-std/Script.sol";
import {SimpleStorage} from "../src/SimpleStorage.sol";

contract DeploySimpleStorage is Script {
    // This is a script to deploy the SimpleStorage contract
    // It uses the Forge standard library for scripting

    //Script has to have this function to run the script
    // It is the entry point for the script
    function run() external returns (SimpleStorage) {
        //vm is from foundry cheat codes
        //This line is saying everything after this line until stop you should send to the rpc
        vm.startBroadcast();
        //Creating new contract to be sent
        SimpleStorage simpleStorage = new SimpleStorage();
        vm.stopBroadcast();

        return simpleStorage;
    }
}
