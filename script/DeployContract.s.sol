// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {ContractV1} from "../src/Contract_v1.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

/**
 * @title DeployContract
 * @author Soumil Vavikar
 * @notice Deploys a new contract and returns the address
 */
contract DeployContract is Script {
    /**
     * @notice Deploys a new contract and returns the address
     */
    function run() external returns (address) {
        // Deploy the contract
        address proxy = deployContract();
        // Return the address of the proxy contract
        return proxy;
    }

    /**
     * @notice Deploys a new contract and returns the address
     */
    function deployContract() public returns (address) {
        vm.startBroadcast();
        // Create an instance of the contract
        ContractV1 contractVar = new ContractV1();
        // Deploying the proxy contract
        ERC1967Proxy proxy = new ERC1967Proxy(address(contractVar), "");
        // Initialize the contract
        ContractV1(address(proxy)).initialize();
        vm.stopBroadcast();
        // Return the address of the proxy contract
        return address(proxy);
    }
}