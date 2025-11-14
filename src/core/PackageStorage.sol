// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "../structs/PackageStructs.sol";

/// @title PackageStorage
/// @notice Storage and retrieval of package metadata (EIP-2678)
contract PackageStorage {
    
    // Package name => version => PackageMeta
    mapping(string => mapping(string => PackageStructs.PackageMeta)) private packageMeta;
    
    // Package name => version => CompilerInfo[]
    mapping(string => mapping(string => PackageStructs.CompilerInfo[])) private compilers;
    
    // Package name => version => contract alias => ContractType
    mapping(string => mapping(string => mapping(string => PackageStructs.ContractType))) private contractTypes;
    
    // Events
    event PackageMetaStored(string indexed name, string version);
    event CompilerInfoStored(string indexed name, string version, uint256 compilerIndex);
    event ContractTypeStored(string indexed name, string version, string contractAlias);
    
    /// @notice Store package metadata
    function storePackageMeta(
        string calldata name,
        string calldata version,
        string[] calldata authors,
        string calldata license,
        string calldata description
    ) external {
        PackageStructs.PackageMeta storage meta = packageMeta[name][version];
        
        // Clear old authors if any
        delete meta.authors;
        
        // Store new data
        for (uint256 i = 0; i < authors.length; i++) {
            meta.authors.push(authors[i]);
        }
        meta.license = license;
        meta.description = description;
        
        emit PackageMetaStored(name, version);
    }
    
    /// @notice Get package metadata
    function getPackageMeta(string calldata name, string calldata version) 
        external 
        view 
        returns (string[] memory authors, string memory license, string memory description) 
    {
        PackageStructs.PackageMeta storage meta = packageMeta[name][version];
        return (meta.authors, meta.license, meta.description);
    }
    
    /// @notice Store compiler information
    function storeCompilerInfo(
        string calldata name,
        string calldata version,
        string calldata compilerName,
        string calldata compilerVersion
    ) external {
        PackageStructs.CompilerInfo memory compiler;
        compiler.name = compilerName;
        compiler.version = compilerVersion;
        
        compilers[name][version].push(compiler);
        
        emit CompilerInfoStored(name, version, compilers[name][version].length - 1);
    }
    
    /// @notice Get compiler information
    function getCompilers(string calldata name, string calldata version) 
        external 
        view 
        returns (PackageStructs.CompilerInfo[] memory) 
    {
        return compilers[name][version];
    }
    
    /// @notice Store contract type
    function storeContractType(
        string calldata name,
        string calldata version,
        string calldata contractAlias,
        string calldata contractName,
        uint256 compilerIndex
    ) external {
        PackageStructs.ContractType storage cType = contractTypes[name][version][contractAlias];
        cType.contractName = contractName;
        cType.compilerIndex = compilerIndex;
        
        emit ContractTypeStored(name, version, contractAlias);
    }
    
    /// @notice Get contract type
    function getContractType(string calldata name, string calldata version, string calldata contractAlias) 
        external 
        view 
        returns (string memory contractName, uint256 compilerIndex) 
    {
        PackageStructs.ContractType storage cType = contractTypes[name][version][contractAlias];
        return (cType.contractName, cType.compilerIndex);
    }
}