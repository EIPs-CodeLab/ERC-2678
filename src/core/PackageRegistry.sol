// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../interfaces/IPackageRegistry.sol";
import "../structs/PackageStructs.sol";

/// @title PackageRegistry
/// @notice On-chain registry for EthPM v3 packages (EIP-2678)
/// @dev Stores package references with content-addressable URIs (IPFS)
contract PackageRegistry is IPackageRegistry {
    
    // Package name => version => manifest URI (IPFS/Swarm)
    mapping(string => mapping(string => string)) private packages;
    
    // Package name => owner address
    mapping(string => address) private packageOwners;
    
    // Package name => all versions
    mapping(string => string[]) private packageVersions;
    
    // Events
    event PackagePublished(string indexed name, string version, string manifestURI, address publisher);
    event PackageOwnershipTransferred(string indexed name, address previousOwner, address newOwner);
    
    /// @notice Publish a package to the registry
    /// @param name Package name (must be lowercase, numbers, hyphens only)
    /// @param version Package version (semver format)
    /// @param manifestURI Content-addressable URI (ipfs:// or bzz://)
    function publish(string calldata name, string calldata version, string calldata manifestURI) external override {
        require(bytes(name).length > 0, "Package name cannot be empty");
        require(bytes(version).length > 0, "Version cannot be empty");
        require(bytes(manifestURI).length > 0, "Manifest URI cannot be empty");
        require(_isValidPackageName(name), "Invalid package name format");
        
        // Check ownership
        if (packageOwners[name] == address(0)) {
            // First time publishing this package
            packageOwners[name] = msg.sender;
        } else {
            // Only owner can publish new versions
            require(packageOwners[name] == msg.sender, "Only package owner can publish");
        }
        
        // Check if version already exists
        require(bytes(packages[name][version]).length == 0, "Version already exists");
        
        // Store package
        packages[name][version] = manifestURI;
        packageVersions[name].push(version);
        
        emit PackagePublished(name, version, manifestURI, msg.sender);
    }
    
    /// @notice Get package manifest URI
    /// @param name Package name
    /// @param version Package version
    /// @return manifestURI The content-addressable URI of the package manifest
    function getPackageURI(string calldata name, string calldata version) external view override returns (string memory) {
        string memory uri = packages[name][version];
        require(bytes(uri).length > 0, "Package version does not exist");
        return uri;
    }
    
    /// @notice Check if package version exists
    /// @param name Package name
    /// @param version Package version
    /// @return exists True if package exists
    function packageExists(string calldata name, string calldata version) external view override returns (bool) {
        return bytes(packages[name][version]).length > 0;
    }
    
    /// @notice Get all versions of a package
    /// @param name Package name
    /// @return versions Array of all versions
    function getVersions(string calldata name) external view returns (string[] memory) {
        return packageVersions[name];
    }
    
    /// @notice Get package owner
    /// @param name Package name
    /// @return owner Address of package owner
    function getOwner(string calldata name) external view returns (address) {
        return packageOwners[name];
    }
    
    /// @notice Transfer package ownership
    /// @param name Package name
    /// @param newOwner New owner address
    function transferOwnership(string calldata name, address newOwner) external {
        require(packageOwners[name] == msg.sender, "Only owner can transfer ownership");
        require(newOwner != address(0), "New owner cannot be zero address");
        
        address previousOwner = packageOwners[name];
        packageOwners[name] = newOwner;
        
        emit PackageOwnershipTransferred(name, previousOwner, newOwner);
    }
    
    /// @notice Validate package name format (lowercase, numbers, hyphens)
    /// @param name Package name to validate
    /// @return valid True if name is valid
    function _isValidPackageName(string calldata name) private pure returns (bool) {
        bytes memory nameBytes = bytes(name);
        
        for (uint256 i = 0; i < nameBytes.length; i++) {
            bytes1 char = nameBytes[i];
            
            // Allow: a-z, 0-9, hyphen
            bool isLowercase = (char >= 0x61 && char <= 0x7A); // a-z
            bool isNumber = (char >= 0x30 && char <= 0x39);    // 0-9
            bool isHyphen = (char == 0x2D);                     // -
            
            if (!isLowercase && !isNumber && !isHyphen) {
                return false;
            }
        }
        
        return true;
    }
}