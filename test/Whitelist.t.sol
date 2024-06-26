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

    function test_SubmitApplication() public {
        vm.prank(nonUser);
        whitelist.submitApplication();
        assertEq(whitelist.isPending(nonUser), true);
    }

    function test_SubmitApplication_MultipleTimes() public {
        vm.prank(nonUser);
        whitelist.submitApplication();
        whitelist.submitApplication();
        assertEq(whitelist.isPending(nonUser), true);
    }

    function test_WithdrawFromWhitelist() public {
        vm.startPrank(pendingUser);

        whitelist.submitApplication();

        assertEq(whitelist.isPending(pendingUser), true);

        whitelist.withdrawApplication();

        assertEq(whitelist.isPending(pendingUser), false);

        vm.stopPrank();
    }

    function testFail_RevertWhen_WithdrawWithoutCallerConfirmation() public {
        vm.expectRevert();
        whitelist.withdrawApplication();
    }

    function test_ApproveApplication() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();

        assertEq(whitelist.isPending(pendingUser), true);

        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);
    }

    function testFail_RevertWhen_ApproveApplication_NotAdmin() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();
        vm.stopPrank();

        vm.startPrank(nonAdmin);

        whitelist.approveApplication(pendingUser);

        vm.stopPrank();
    }

    function test_RevokeRole() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);

        whitelist.rejectApplication(pendingUser);

        assertEq(whitelist.isGranted(pendingUser), false);
    }

    function testFail_RevokeRole_NotAdmin() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);

        vm.startPrank(pendingUser);

        whitelist.rejectApplication(pendingUser);

        vm.stopPrank();
    }

    function test_isGranted_notGranted() public view {
        assertEq(whitelist.isGranted(nonAdmin), false);
    }

    function test_isGranted_Granted() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);
    }

    function test_isPending_notPending() public view {
        assertEq(whitelist.isPending(nonAdmin), false);
    }

    function test_isPending_Pending() public {
        vm.startPrank(nonUser);
        whitelist.submitApplication();
        assertEq(whitelist.isPending(nonUser), true);
    }

    function test_isPending_afterApplicationApproval() public {
        vm.startPrank(pendingUser);
        whitelist.submitApplication();
        vm.stopPrank();

        whitelist.approveApplication(pendingUser);

        assertEq(whitelist.isPending(pendingUser), false);
        assertEq(whitelist.isGranted(pendingUser), true);
    }

    function test_isAdmin_NonAdmin() public view {
        assertEq(whitelist.isAdmin(nonAdmin), false);
    }

    function test_isAdmin_Admin() public view {
        assertEq(whitelist.isAdmin(address(this)), true);
    }

    function test_isAdmin_AfterOwnershipTransferred() public {
        whitelist.transferOwnership(nonAdmin);
        assertEq(whitelist.isAdmin(nonAdmin), true);
        assertEq(whitelist.isAdmin(address(this)), false);
    }
}