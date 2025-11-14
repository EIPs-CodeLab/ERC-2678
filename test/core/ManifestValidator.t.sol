// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/core/ManifestValidator.sol";

contract ManifestValidatorTest is Test {
    
    function testValidContractNames() public {
        assertTrue(ManifestValidator.isValidContractName("Wallet"));
        assertTrue(ManifestValidator.isValidContractName("_MyContract"));
        assertTrue(ManifestValidator.isValidContractName("$Dollar"));
        assertTrue(ManifestValidator.isValidContractName("Contract123"));
        assertTrue(ManifestValidator.isValidContractName("a"));
    }
    
    function testInvalidContractNames() public {
        assertFalse(ManifestValidator.isValidContractName(""));              // Empty
        assertFalse(ManifestValidator.isValidContractName("123Contract"));   // Starts with number
        assertFalse(ManifestValidator.isValidContractName("My-Contract"));   // Contains hyphen
        assertFalse(ManifestValidator.isValidContractName("My Contract"));   // Contains space
    }
    
    function testValidPackageNames() public {
        assertTrue(ManifestValidator.isValidPackageName("safe-math-lib"));
        assertTrue(ManifestValidator.isValidPackageName("wallet"));
        assertTrue(ManifestValidator.isValidPackageName("erc20-token"));
        assertTrue(ManifestValidator.isValidPackageName("lib123"));
    }
    
    function testInvalidPackageNames() public {
        assertFalse(ManifestValidator.isValidPackageName(""));
        assertFalse(ManifestValidator.isValidPackageName("Invalid_Name"));    // Underscore
        assertFalse(ManifestValidator.isValidPackageName("UpperCase"));       // Uppercase
        assertFalse(ManifestValidator.isValidPackageName("my package"));      // Space
    }
    
    function testValidContractAlias() public {
        assertTrue(ManifestValidator.isValidContractAlias("Wallet"));
        assertTrue(ManifestValidator.isValidContractAlias("Wallet-v2"));
        assertTrue(ManifestValidator.isValidContractAlias("owned_Owned"));
    }
    
    function testValidManifestVersion() public {
        assertTrue(ManifestValidator.isValidManifestVersion("ethpm/3"));
        assertFalse(ManifestValidator.isValidManifestVersion("ethpm/2"));
        assertFalse(ManifestValidator.isValidManifestVersion("v3"));
    }
    
    function testForbiddenKeys() public {
        assertTrue(ManifestValidator.isForbiddenKey("manifest_version"));
        assertFalse(ManifestValidator.isForbiddenKey("manifest"));
        assertFalse(ManifestValidator.isForbiddenKey("version"));
    }
}