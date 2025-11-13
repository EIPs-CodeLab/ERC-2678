// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "../../src/interfaces/IPackageRegistry.sol";

contract MockPackageRegistry is IPackageRegistry {
    mapping(bytes32 => string) private packages;
    
    function publish(string calldata name, string calldata version, string calldata manifestURI) external {
        bytes32 key = keccak256(abi.encodePacked(name, version));
        packages[key] = manifestURI;
    }
    
    function getPackageURI(string calldata name, string calldata version) external view returns (string memory) {
        bytes32 key = keccak256(abi.encodePacked(name, version));
        return packages[key];
    }
    
    function packageExists(string calldata name, string calldata version) external view returns (bool) {
        bytes32 key = keccak256(abi.encodePacked(name, version));
        return bytes(packages[key]).length > 0;
    }
}

contract IPackageRegistryTest is Test {
    MockPackageRegistry registry;
    
    function setUp() public {
        registry = new MockPackageRegistry();
    }
    
    function testPublishPackage() public {
        registry.publish("safe-math-lib", "1.0.0", "ipfs://QmTest123");
        assertTrue(registry.packageExists("safe-math-lib", "1.0.0"));
    }
    
    function testGetPackageURI() public {
        string memory manifestURI = "ipfs://QmTest123";
        registry.publish("wallet", "2.1.0", manifestURI);
        
        assertEq(registry.getPackageURI("wallet", "2.1.0"), manifestURI);
    }
    
    function testPackageNotExists() public {
        assertFalse(registry.packageExists("nonexistent", "1.0.0"));
    }
}
