// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Whitelist is AccessControl {
    bytes32 public constant MINTER_ROLE = keccak256("PENDING");
    bytes32 public constant BURNER_ROLE = keccak256("GRANTED");

    string public greeting = "Hello, World!";

    constructor(){
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function getGreeting() public view returns (string memory) {
        return greeting;
    }
}