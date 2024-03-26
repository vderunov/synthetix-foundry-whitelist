// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Whitelist} from "../src/Whitelist.sol";

contract WhitelistTest is Test {
    Whitelist public whitelist;

    function setUp() public {
        whitelist = new Whitelist();
    }

    function test_CallerIsAdmin() public view {
        assertEq(whitelist.isAdmin(address(this)), true);
    }

    function testFail_CallerIsNotAdmin() public {
        vm.prank(address(0));
        assertEq(whitelist.isAdmin(address(this)), false);
    }
}