// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {DeployContract} from "../script/DeployContract.s.sol";
import {UpgradeContract} from "../script/UpgradeContract.s.sol";
import {Test, console} from "forge-std/Test.sol";
import {StdCheats} from "forge-std/StdCheats.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {ContractV1} from "../src/Contract_v1.sol";
import {ContractV2} from "../src/Contract_v2.sol";

/**
 * @title DeployAndUpgradeTest
 * @author Soumil Vavikar
 * @notice Test contract for deploying and upgrading contracts
 */
contract DeployAndUpgradeTest is StdCheats, Test {
    DeployContract public deployContract;
    UpgradeContract public upgradeContract;

    /**
     * @notice Set up the test
     */
    function setUp() public {
        deployContract = new DeployContract();
        upgradeContract = new UpgradeContract();
    }

    /**
     * @notice Test the contract works
     */
    function testContractWorks() public {
        address proxyAddress = deployContract.deployContract();
        uint256 expectedValue = 1;
        assertEq(expectedValue, ContractV1(proxyAddress).version());
    }

    /**
     * @notice Test the contract works
     */
    function testDeploymentIsV1() public {
        address proxyAddress = deployContract.deployContract();
        uint256 expectedValue = 7;
        vm.expectRevert();
        ContractV2(proxyAddress).setValue(expectedValue);
    }

    /**
     * @notice Test the upgrade capability works
     */
    function testUpgradeWorks() public {
        address proxyAddress = deployContract.deployContract();

        ContractV2 Contract2 = new ContractV2();

        vm.prank(ContractV1(proxyAddress).owner());
        ContractV1(proxyAddress).transferOwnership(msg.sender);

        address proxy = upgradeContract.upgradeContract(proxyAddress, address(Contract2));

        assertEq(2, ContractV2(proxy).version());

        uint256 expectedValue = 7;
        ContractV2(proxy).setValue(expectedValue);
        assertEq(expectedValue, ContractV2(proxy).getValue());
    }
}
