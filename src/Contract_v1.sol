// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title ContractV1
 * @author Soumil Vavikar
 * @notice Example contract V1
 */
contract ContractV1 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal value;

    // We cannot have contrcutor in upgradeable contracts as:
    // - the constructor will use storage within the implementation contract
    // - But we want the storage within the proxy contract to be used
    // - the proxy contract will call the initialize function

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        // This doesn't let the contract to be initialized using constructor
        _disableInitializers();
    }

    function initialize() public initializer {
        // Add whatever you want to do in the constructor here. 
        // The proxy will call this initialize function and not the constructor.

        // the below line is equal to owner = msg.sender;
        __Ownable_init(msg.sender);
        // This won't do much is a good practice to have it here.
        __UUPSUpgradeable_init();
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function version() public pure returns (uint256) {
        return 1;
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {}
}
