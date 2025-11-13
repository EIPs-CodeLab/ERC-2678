// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title PackageStructs
/// @notice All data structures from EIP-2678 (EthPM v3)
/// @dev Based on https://eips.ethereum.org/EIPS/eip-2678
library PackageStructs {
    
    /// @notice Package Meta Object from EIP-2678
    struct PackageMeta {
        string[] authors;          // Human readable author names
        string license;            // SPDX format license
        string description;        // Package description
        string[] keywords;         // Relevant keywords
        string website;            // Primary website
        string documentation;      // Documentation link
        string repository;         // Source code location
    }
    
    /// @notice Compiler Information Object from EIP-2678
    struct CompilerInfo {
        string name;               // Compiler name (e.g., "solc")
        string version;            // Semver or commit hash (e.g., "0.8.0" or "0.4.8-commit.60cc1668")
        bytes settings;            // Compiler settings as bytes
    }
    
    /// @notice Contract Type from EIP-2678
    struct ContractType {
        string contractName;       // Name from source code (e.g., "Wallet")
        bytes abi;                 // JSON ABI as bytes
        bytes bytecode;            // Unlinked deployment bytecode
        bytes runtimeBytecode;     // Unlinked runtime bytecode
        string sourceId;           // Reference to source file
        uint256 compilerIndex;     // Index in compilers array
    }
    
    /// @notice Contract Instance Object from EIP-2678
    struct ContractInstance {
        string contractType;       // Reference to Contract Type (e.g., "Wallet" or "owned:Owned")
        address instanceAddress;   // Deployed contract address
        bytes32 transaction;       // Deployment transaction hash
        uint256 blockNumber;       // Deployment block number
        bytes runtimeBytecode;     // Linked runtime bytecode
    }
    
    /// @notice Link Reference Object from EIP-2678
    struct LinkReference {
        uint256[] offsets;         // Start positions in bytecode (0-indexed)
        uint256 length;            // Length in bytes of the reference
        string name;               // Identifier for linking
    }
    
    /// @notice Link Value Object from EIP-2678
    struct LinkValue {
        uint256[] offsets;         // Locations where value was written
        string valueType;          // "literal" for bytecode literals, "reference" for named references
        string value;              // 0x-prefixed hex string or contract instance name
    }
    
    /// @notice Deployment information per chain from EIP-2678
    struct DeploymentInfo {
        string chainURI;           // BIP122 URI (e.g., blockchain://<chain_id>/block/<block_hash>)
        ContractInstance[] instances; // Array of deployed contract instances
    }
    
    /// @notice Source file information from EIP-2678
    struct SourceInfo {
        string sourceId;           // Unique identifier for source file
        string content;            // Source code content or IPFS hash
        string license;            // SPDX license (overrides package license)
    }
}