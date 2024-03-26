// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Whitelist} from "../src/Whitelist.sol";
he
contract WhitelistTest is Test {
    Whitelist public whitelist;

    function setUp() public {
        whitelist = new Whitelist();
    }

    function test_getGreeting() public view {
        assertEq(whitelist.getGreeting(), "Hello, World!");
    }
}