// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/core/PackageRegistry.sol";

contract PackageRegistryTest is Test {
    PackageRegistry registry;
    address alice = address(0x1);
    address bob = address(0x2);
    
    function setUp() public {
        registry = new PackageRegistry();
    }
    
    function testPublishPackage() public {
        vm.prank(alice);
        registry.publish("safe-math-lib", "1.0.0", "ipfs://QmTest123");
        
        assertTrue(registry.packageExists("safe-math-lib", "1.0.0"));
        assertEq(registry.getPackageURI("safe-math-lib", "1.0.0"), "ipfs://QmTest123");
    }
    
    function testPackageOwnership() public {
        vm.prank(alice);
        registry.publish("wallet", "1.0.0", "ipfs://QmWallet1");
        
        assertEq(registry.getOwner("wallet"), alice);
    }
    
    function testOnlyOwnerCanPublishNewVersion() public {
        vm.prank(alice);
        registry.publish("token", "1.0.0", "ipfs://QmToken1");
        
        vm.prank(bob);
        vm.expectRevert("Only package owner can publish");
        registry.publish("token", "1.1.0", "ipfs://QmToken2");
    }
    
    function testCannotPublishDuplicateVersion() public {
        vm.prank(alice);
        registry.publish("escrow", "1.0.0", "ipfs://QmEscrow1");
        
        vm.prank(alice);
        vm.expectRevert("Version already exists");
        registry.publish("escrow", "1.0.0", "ipfs://QmEscrow2");
    }
    
    function testInvalidPackageName() public {
        vm.prank(alice);
        vm.expectRevert("Invalid package name format");
        registry.publish("Invalid_Name", "1.0.0", "ipfs://QmTest");
    }
    
    function testValidPackageNames() public {
        vm.startPrank(alice);
        
        registry.publish("valid-name", "1.0.0", "ipfs://Qm1");
        registry.publish("name123", "1.0.0", "ipfs://Qm2");
        registry.publish("123name", "1.0.0", "ipfs://Qm3");
        registry.publish("my-package-v2", "1.0.0", "ipfs://Qm4");
        
        vm.stopPrank();
        
        assertTrue(registry.packageExists("valid-name", "1.0.0"));
        assertTrue(registry.packageExists("name123", "1.0.0"));
    }
    
    function testGetVersions() public {
        vm.startPrank(alice);
        registry.publish("mylib", "1.0.0", "ipfs://Qm1");
        registry.publish("mylib", "1.1.0", "ipfs://Qm2");
        registry.publish("mylib", "2.0.0", "ipfs://Qm3");
        vm.stopPrank();
        
        string[] memory versions = registry.getVersions("mylib");
        assertEq(versions.length, 3);
    }
    
    function testTransferOwnership() public {
        vm.prank(alice);
        registry.publish("transferable", "1.0.0", "ipfs://QmTransfer");
        
        vm.prank(alice);
        registry.transferOwnership("transferable", bob);
        
        assertEq(registry.getOwner("transferable"), bob);
        
        // Bob can now publish new versions
        vm.prank(bob);
        registry.publish("transferable", "1.1.0", "ipfs://QmTransfer2");
        
        assertTrue(registry.packageExists("transferable", "1.1.0"));
    }
}