// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IPackageRegistry
/// @notice Interface for EthPM v3 Package Registry based on EIP-2678
/// @dev Defines functions for publishing and retrieving packages
interface IPackageRegistry {
    /// @notice Publish a package to the registry
    /// @param name Package name (lowercase, numbers, hyphens only)
    /// @param version Package version
    /// @param manifestURI Content-addressable URI (e.g., ipfs://)
    function publish(string calldata name, string calldata version, string calldata manifestURI) external;
    
    /// @notice Get package manifest URI
    /// @param name Package name
    /// @param version Package version
    /// @return manifestURI The content-addressable URI of the package manifest
    function getPackageURI(string calldata name, string calldata version) external view returns (string memory);
    
    /// @notice Check if package version exists
    /// @param name Package name
    /// @param version Package version
    /// @return exists True if package exists
    function packageExists(string calldata name, string calldata version) external view returns (bool);
}

