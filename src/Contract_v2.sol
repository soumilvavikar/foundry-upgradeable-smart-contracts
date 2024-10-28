// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

/**
 * @title ContractV2
 * @author Soumil Vavikar
 * @notice Example contract V2
 */
contract ContractV2 is Initializable, OwnableUpgradeable, UUPSUpgradeable {
    uint256 internal value;

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

    function setValue(uint256 _value) public {
        value = _value;
    }

    function getValue() public view returns (uint256) {
        return value;
    }

    function version() public pure returns (uint256) {
        return 2;
    }

    function _authorizeUpgrade(address newImplementation) internal virtual override {}
}
