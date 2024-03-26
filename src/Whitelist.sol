// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Whitelist is AccessControl {
    bytes32 public constant PENDING_USER_ROLE = keccak256("PENDING");
    bytes32 public constant GRANTED_USER_ROLE = keccak256("GRANTED");

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
    }

    function applyForWhitelist() public {
        _grantRole(PENDING_USER_ROLE, msg.sender);
    }

    function withdraw() public {
        renounceRole(PENDING_USER_ROLE, msg.sender);
    }

    function approveApplication(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(GRANTED_USER_ROLE, user);
        _revokeRole(PENDING_USER_ROLE, user);
    }

    function revoke(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(GRANTED_USER_ROLE, user);
    }

    function isGranted(address user) public view returns (bool) {
        return hasRole(GRANTED_USER_ROLE, user);
    }

    function isPending(address user) public view returns (bool) {
        return hasRole(PENDING_USER_ROLE, user);
    }

    function isAdmin(address user) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, user);
    }
}