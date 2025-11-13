// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title IPackageManifest
/// @notice Interface for EthPM v3 Package Manifest structure based on EIP-2678
interface IPackageManifest {
    /// @notice Package Meta Object from EIP-2678
    struct PackageMeta {
        string[] authors;      // Human readable names
        string license;        // SPDX format
        string description;    // Additional detail
        string[] keywords;     // Relevant keywords
        mapping(string => string) links; // URIs (website, docs, repo)
    }
    
    /// @notice Compiler Information Object from EIP-2678
    struct CompilerInfo {
        string name;           // Compiler name (e.g., "solc")
        string version;        // Semver or commit hash format
    }
    
    /// @notice Contract Instance Object from EIP-2678
    struct ContractInstance {
        string contractType;   // Reference to Contract Type
        address instanceAddress; // Deployed address
    }
    
    /// @notice Link Reference Object from EIP-2678
    struct LinkReference {
        uint256[] offsets;     // Start positions in bytecode (0-indexed)
        uint256 length;        // Length in bytes
        string name;           // Identifier for linking
    }
    
    /// @notice Link Value Object from EIP-2678
    struct LinkValue {
        uint256[] offsets;     // Locations where value was written
        string valueType;      // "literal" or "reference"
        string value;          // Value to write when linking
    }
}