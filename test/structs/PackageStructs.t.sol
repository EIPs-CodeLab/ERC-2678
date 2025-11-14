// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/structs/PackageStructs.sol";

contract PackageStructsTest is Test {
    
    function testPackageMeta() public {
        PackageStructs.PackageMeta memory meta;
        meta.authors = new string[](2);
        meta.authors[0] = "Satoshi";
        meta.authors[1] = "Vitalik";
        meta.license = "MIT";
        meta.description = "A safe math library";
        meta.keywords = new string[](2);
        meta.keywords[0] = "math";
        meta.keywords[1] = "library";
        meta.website = "https://example.com";
        
        assertEq(meta.authors[0], "Satoshi");
        assertEq(meta.license, "MIT");
        assertEq(meta.keywords.length, 2);
    }
    
    function testCompilerInfo() public {
        PackageStructs.CompilerInfo memory compiler;
        compiler.name = "solc";
        compiler.version = "0.8.0";
        
        assertEq(compiler.name, "solc");
        assertEq(compiler.version, "0.8.0");
    }
    
    function testContractType() public {
        PackageStructs.ContractType memory cType;
        cType.contractName = "Wallet";
        cType.sourceId = "contracts/Wallet.sol";
        cType.compilerIndex = 0;
        
        assertEq(cType.contractName, "Wallet");
        assertEq(cType.sourceId, "contracts/Wallet.sol");
    }
    
    function testContractInstance() public {
        PackageStructs.ContractInstance memory instance;
        instance.contractType = "Wallet";
        instance.instanceAddress = address(0x1234567890123456789012345678901234567890);
        instance.transaction = keccak256("deployment_tx");
        instance.blockNumber = 12345;
        
        assertEq(instance.contractType, "Wallet");
        assertEq(instance.instanceAddress, address(0x1234567890123456789012345678901234567890));
        assertEq(instance.blockNumber, 12345);
    }
    
    function testLinkReference() public {
        PackageStructs.LinkReference memory ref;
        ref.offsets = new uint256[](2);
        ref.offsets[0] = 10;
        ref.offsets[1] = 50;
        ref.length = 20;
        ref.name = "SafeMath";
        
        assertEq(ref.offsets[0], 10);
        assertEq(ref.offsets[1], 50);
        assertEq(ref.length, 20);
        assertEq(ref.name, "SafeMath");
    }
    
    function testLinkValue() public {
        PackageStructs.LinkValue memory val;
        val.offsets = new uint256[](1);
        val.offsets[0] = 100;
        val.valueType = "literal";
        val.value = "0x1234";
        
        assertEq(val.offsets[0], 100);
        assertEq(val.valueType, "literal");
        assertEq(val.value, "0x1234");
    }
    
    function testDeploymentInfo() public {
        PackageStructs.DeploymentInfo memory deployment;
        deployment.chainURI = "blockchain://1/block/0x123abc";
        deployment.instances = new PackageStructs.ContractInstance[](1);
        
        deployment.instances[0].contractType = "Token";
        deployment.instances[0].instanceAddress = address(0x999);
        deployment.instances[0].blockNumber = 99999;
        
        assertEq(deployment.chainURI, "blockchain://1/block/0x123abc");
        assertEq(deployment.instances.length, 1);
        assertEq(deployment.instances[0].contractType, "Token");
    }
    
    function testSourceInfo() public {
        PackageStructs.SourceInfo memory source;
        source.sourceId = "contracts/Token.sol";
        source.content = "ipfs://Qm...";
        source.license = "GPL-3.0";
        
        assertEq(source.sourceId, "contracts/Token.sol");
        assertEq(source.license, "GPL-3.0");
    }
}

