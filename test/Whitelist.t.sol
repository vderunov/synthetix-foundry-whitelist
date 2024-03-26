// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test} from "forge-std/Test.sol";
import {Whitelist} from "../src/Whitelist.sol";

contract WhitelistTest is Test {
    Whitelist public whitelist;
    address public nonAdmin;
    address public nonUser;
    address public pendingUser;

    function setUp() public {
        whitelist = new Whitelist();
        nonAdmin = address(0x1);
        nonUser = address(0x2);
        pendingUser = address(0x3);
    }

    function test_OwnerIsAdmin() public view {
        assertEq(whitelist.isAdmin(address(this)), true);
    }

    function testFail_NonAdminCannotTransferOwnership() public {
        vm.prank(nonAdmin);
        whitelist.transferOwnership(nonAdmin);
    }

    function test_RevertWhen_TransferOwnershipToZeroAddress() public {
        vm.expectRevert("New owner is the zero address");
        whitelist.transferOwnership(address(0));
    }

    function test_TransferOwnership() public {
        whitelist.transferOwnership(nonAdmin);
        assertEq(whitelist.isAdmin(nonAdmin), true);
        assertEq(whitelist.isAdmin(address(this)), false);
    }

    function test_ApplyForWhitelist() public {
        vm.prank(nonUser);
        whitelist.applyForWhitelist();
        assertEq(whitelist.isPending(nonUser), true);
    }

    function test_ApplyForWhitelist_MultipleTimes() public {
        vm.prank(nonUser);
        whitelist.applyForWhitelist();
        whitelist.applyForWhitelist();
        assertEq(whitelist.isPending(nonUser), true);
    }

    function test_WithdrawFromWhitelist() public {
        vm.startPrank(pendingUser);

        whitelist.applyForWhitelist();

        assertEq(whitelist.isPending(pendingUser), true);

        whitelist.withdraw();

        assertEq(whitelist.isPending(pendingUser), false);

        vm.stopPrank();
    }

    function testFail_RevertWhen_WithdrawWithoutCallerConfirmation() public {
        vm.expectRevert();
        whitelist.withdraw();
    }

    function test_ApproveApplication() public {
        vm.startPrank(pendingUser);
        whitelist.applyForWhitelist();

        assertEq(whitelist.isPending(pendingUser), true);

        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);
    }

    function testFail_RevertWhen_ApproveApplication_NotAdmin() public {
        vm.startPrank(pendingUser);
        whitelist.applyForWhitelist();
        vm.stopPrank();

        vm.startPrank(nonAdmin);

        whitelist.approveApplication(pendingUser);

        vm.stopPrank();
    }

    function test_RevokeRole() public {
        vm.startPrank(pendingUser);
        whitelist.applyForWhitelist();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);

        whitelist.revoke(pendingUser);

        assertEq(whitelist.isGranted(pendingUser), false);
    }

    function testFail_RevokeRole_NotAdmin() public {
        vm.startPrank(pendingUser);
        whitelist.applyForWhitelist();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);

        vm.startPrank(pendingUser);

        whitelist.revoke(pendingUser);

        vm.stopPrank();
    }
}