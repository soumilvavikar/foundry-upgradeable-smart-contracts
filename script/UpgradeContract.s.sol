// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {Script} from "forge-std/Script.sol";
import {ContractV1} from "../src/Contract_v1.sol";
import {ContractV2} from "../src/Contract_v2.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

/**
 * @title UpgradeContract
 * @author Soumil Vavikar
 * @notice Upgrades the most recently deployed contract
 */
contract UpgradeContract is Script {
    /**
     * @notice Upgrades the most recently deployed contract
     */
    function run() external returns (address) {
        // Get the most recently deployed proxy contract
        address mostRecentlyDeployedProxy = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        // Deploy the new contract / Create an instance of the new contract
        ContractV2 newContract = new ContractV2();
        vm.stopBroadcast();
        // Upgrade the most recently deployed contract
        address proxy = upgradeContract(mostRecentlyDeployedProxy, address(newContract));
        // Return the address of the proxy contract
        return proxy;
    }

    /**
     * @notice Upgrades the contract at the given proxy address
     * @param proxyAddress - proxy address
     * @param newContract - new contact address
     */
    function upgradeContract(address proxyAddress, address newContract) public returns (address) {
        vm.startBroadcast();
        // Get the proxy for contractV1
        ContractV1 proxy = ContractV1(payable(proxyAddress));
        // Upgrade the proxy to the new contract
        proxy.upgradeToAndCall(address(newContract), "");
        vm.stopBroadcast();
        // Return the address of the proxy contract
        return address(proxy);
    }
}