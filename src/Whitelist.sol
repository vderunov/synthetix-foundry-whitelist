// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {AccessControl} from "@openzeppelin/contracts/access/AccessControl.sol";

contract Whitelist is AccessControl {
    bytes32 public constant PENDING = "pending";
    bytes32 public constant GRANTED = "granted";

    constructor() {
        _grantRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function transferOwnership(address newOwner) public onlyRole(DEFAULT_ADMIN_ROLE) {
        require(newOwner != address(0), "New owner is the zero address");
        _grantRole(DEFAULT_ADMIN_ROLE, newOwner);
        _revokeRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function applyForWhitelist() public {
        _grantRole(PENDING, _msgSender());
    }

    function renounceAssignedRole() public {
        renounceRole(PENDING, _msgSender());
    }

    function approveApplication(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _grantRole(GRANTED, user);
        _revokeRole(PENDING, user);
    }

    function revokeAccess(address user) public onlyRole(DEFAULT_ADMIN_ROLE) {
        _revokeRole(GRANTED, user);
    }

    function isGranted(address user) public view returns (bool) {
        return hasRole(GRANTED, user);
    }

    function isPending(address user) public view returns (bool) {
        return hasRole(PENDING, user);
    }

    function isAdmin(address user) public view returns (bool) {
        return hasRole(DEFAULT_ADMIN_ROLE, user);
    }
}