# ERC-2678: Revised Ethereum Smart Contract Packaging Standard (EthPM v3)

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.29-blue)](https://soliditylang.org/)
[![Tests](https://img.shields.io/badge/Tests-28%20Passed-brightgreen)](./test)

A Solidity implementation of EIP-2678, the Ethereum Package Manager v3 specification for smart contract packaging and distribution.

## Overview

ERC-2678 defines a standardized data format for packaging smart contracts, including:
- Source code and compiled artifacts
- Deployment information across multiple networks
- Contract dependencies and linking
- Package metadata (authors, license, documentation)

This implementation provides:
- **On-chain Package Registry** for publishing and retrieving packages
- **Manifest Validation** according to EIP-2678 rules
- **Data Structures** mirroring the EthPM v3 specification
- **Package Storage** for metadata management

### Key Features

✅ Package publishing with IPFS/Swarm integration  
✅ Multi-chain deployment tracking via BIP122 URIs  
✅ Contract type and instance management  
✅ Bytecode linking support  
✅ Package versioning and ownership control  
✅ EIP-2678 compliant validation (naming, structure)

## Specification

### Package Manifest Structure

Packages are distributed as **alphabetically-ordered, minified JSON** with the following components:

- **manifest**: Must be `"ethpm/3"` (v3 identifier)
- **name**: Package name (lowercase, numbers, hyphens only)
- **version**: Semantic versioning (e.g., `1.0.0`)
- **meta**: Package metadata (authors, license, description, keywords, links)
- **sources**: Source code files
- **contractTypes**: Contract definitions (ABI, bytecode, source references)
- **deployments**: Deployed instances per chain (BIP122 URIs)
- **compilers**: Compiler information (name, version, settings)

### Naming Conventions

**Package Names:**
- Pattern: `^[a-z0-9-]+$`
- Examples: `safe-math-lib`, `erc20-token`, `wallet-v2`

**Contract Names:**
- Pattern: `^[a-zA-Z_$][a-zA-Z0-9_$]{0,255}$`
- Examples: `Wallet`, `_MyContract`, `$Dollar`, `ERC20Token`

**Contract Aliases:**
- Pattern: `^[a-zA-Z][-_a-zA-Z0-9]{0,255}$`
- Examples: `Wallet`, `owned:Owned`, `SafeMath-v1`

### BIP122 Chain Identification

Chain URIs follow the format:
```
blockchain://<chain_id>/block/<block_hash>
```

Where:
- `chain_id`: Unprefixed hex of genesis block hash
- `block_hash`: Unprefixed hex of a reliable block hash

## Implementation

### Project Structure
```
src/
├── interfaces/
│   ├── IPackageRegistry.sol      # Registry interface
│   └── IPackageManifest.sol      # Manifest structure interface
├── core/
│   ├── PackageRegistry.sol       # Main registry implementation
│   ├── ManifestValidator.sol     # EIP-2678 validation rules
│   └── PackageStorage.sol        # Metadata storage
├── PackageStructs.sol            # All EIP-2678 data structures
test/
├── interfaces/
│   └── IPackageRegistry.t.sol
├── core/
│   ├── PackageRegistry.t.sol
│   └── ManifestValidator.t.sol
└── structs/
    └── PackageStructs.t.sol
```

### Core Components

#### PackageRegistry

Main contract for publishing and retrieving packages:
```solidity
// Publish a package
function publish(string calldata name, string calldata version, string calldata manifestURI) external;

// Retrieve package manifest URI
function getPackageURI(string calldata name, string calldata version) external view returns (string memory);

// Check if package exists
function packageExists(string calldata name, string calldata version) external view returns (bool);

// Transfer package ownership
function transferOwnership(string calldata name, address newOwner) external;
```

#### ManifestValidator

Library for validating EIP-2678 compliance:
```solidity
// Validate package name (lowercase, numbers, hyphens)
function isValidPackageName(string memory name) internal pure returns (bool);

// Validate contract name (^[a-zA-Z_$][a-zA-Z0-9_$]{0,255}$)
function isValidContractName(string memory name) internal pure returns (bool);

// Validate contract alias
function isValidContractAlias(string memory contractAlias) internal pure returns (bool);

// Validate manifest version is "ethpm/3"
function isValidManifestVersion(string memory version) internal pure returns (bool);
```

#### PackageStructs

All EIP-2678 data structures:

- `PackageMeta` - Package metadata
- `CompilerInfo` - Compiler information
- `ContractType` - Contract definitions
- `ContractInstance` - Deployed instances
- `LinkReference` - Bytecode linking references
- `LinkValue` - Link values for bytecode
- `DeploymentInfo` - Multi-chain deployments
- `SourceInfo` - Source file information

## Installation

### Prerequisites

- [Foundry](https://book.getfoundry.sh/getting-started/installation)

### Setup
```bash
# Clone the repository
git clone https://github.com/EIPs-CodeLab/ERC-2678.git
cd ERC-2678

# Install dependencies
forge install

# Build contracts
forge build

# Run tests
forge test
```

## Usage Examples

### Publishing a Package
```solidity
import {PackageRegistry} from "./src/core/PackageRegistry.sol";

// Deploy registry
PackageRegistry registry = new PackageRegistry();

// Publish package with IPFS manifest
registry.publish(
    "safe-math-lib",           // Package name
    "1.0.0",                   // Version
    "ipfs://QmXYZ123..."       // Manifest URI
);
```

### Retrieving a Package
```solidity
// Get package manifest URI
string memory manifestURI = registry.getPackageURI("safe-math-lib", "1.0.0");

// Check if package exists
bool exists = registry.packageExists("safe-math-lib", "1.0.0");

// Get all versions
string[] memory versions = registry.getVersions("safe-math-lib");
```

### Validating Names
```solidity
import {ManifestValidator} from "./src/core/ManifestValidator.sol";

// Validate package name
bool valid = ManifestValidator.isValidPackageName("my-package");  // true
bool invalid = ManifestValidator.isValidPackageName("My_Package"); // false

// Validate contract name
bool valid = ManifestValidator.isValidContractName("MyContract");  // true
bool invalid = ManifestValidator.isValidContractName("123Invalid"); // false
```

### Using Structs
```solidity
import {PackageStructs} from "./src/PackageStructs.sol";

// Create package metadata
PackageStructs.PackageMeta memory meta;
meta.authors = ["Alice", "Bob"];
meta.license = "MIT";
meta.description = "A safe math library";

// Create contract instance
PackageStructs.ContractInstance memory instance;
instance.contractType = "SafeMath";
instance.instanceAddress = 0x1234...;
instance.blockNumber = 12345;
```

## Test Cases

Run the complete test suite:
```bash
# Run all tests
forge test

# Run with verbose output
forge test -vvv

# Run specific test file
forge test --match-path test/core/PackageRegistry.t.sol

# Run with gas reporting
forge test --gas-report
```

### Test Coverage
```
Total: 28 tests
✓ Interface tests: 3 passed
✓ Struct tests: 8 passed
✓ Registry tests: 8 passed
✓ Validator tests: 7 passed
✓ Counter tests: 2 passed
```

### Key Test Scenarios

- Package publishing with valid names
- Ownership control and transfer
- Version duplication prevention
- Name validation (package and contract)
- Manifest version validation
- Multi-version package management
- Access control enforcement

## Rationale

### Why EthPM v3?

**Version 3 Improvements:**

1. **Compiler Compatibility**: Schema now matches compiler metadata output
2. **Enhanced Sources**: Supports wider range of source file types
3. **Simplified Compilers**: Top-level array reduces duplication
4. **Naming Convention**: Changed to camelCase for JSON consistency
5. **Backwards Compatibility**: Uses `"manifest": "ethpm/3"` instead of `manifest_version`

### Design Decisions

**Package Names (lowercase only):**
- Improves readability and security
- Reduces confusion between similar characters (O vs 0)
- Prevents malicious packages with look-alike names

**BIP122 Chain URIs:**
- Industry standard for blockchain identification
- Distinguishes between forks
- Enables multi-chain deployment tracking

**Content-Addressable Storage:**
- IPFS/Swarm ensure immutable package distribution
- Same assets always resolve to same URI
- Cryptographic verification of integrity

**Minified JSON:**
- Reduces storage costs
- Ensures consistency across implementations
- Alphabetical ordering guarantees deterministic hashing

## Security Considerations

### ⚠️ Critical Security Notice

**Using EthPM packages implicitly requires importing and/or executing code written by others.**

The EthPM specification guarantees:
-  **Code Integrity**: You will have the exact same code that was included in the package by the package author
- **Immutability**: Content-addressed storage ensures packages cannot be modified after release
- **Verification**: On-chain registry provides transparent package history

The EthPM specification **CANNOT** guarantee:
-  **Code Safety**: The code itself may contain vulnerabilities or malicious logic
-  **Author Intent**: Package authors may have malicious intentions
-  **Dependency Security**: Dependencies may contain vulnerabilities

### Best Practices

1. **Trust but Verify**
   - Only use packages from trusted individuals/organizations
   - Audit code before deployment
   - Review package dependencies

2. **Ownership Verification**
   - Check package owner address
   - Verify package authenticity through official channels
   - Be cautious of similar package names

3. **Version Pinning**
   - Use specific versions in production
   - Review changes between versions
   - Test upgrades in staging environments

4. **Source Code Review**
   - Always review source code before use
   - Check for suspicious patterns
   - Verify against published audits

5. **Testing**
   - Thoroughly test packages in your context
   - Use testnets before mainnet deployment
   - Monitor deployed contracts

## References

- **EIP-2678 Specification**: [https://eips.ethereum.org/EIPS/eip-2678](https://eips.ethereum.org/EIPS/eip-2678)
- **EIP-1319 (Registry Standard)**: [https://eips.ethereum.org/EIPS/eip-1319](https://eips.ethereum.org/EIPS/eip-1319)
- **BIP-122 (Chain URIs)**: [https://github.com/bitcoin/bips/blob/master/bip-0122.mediawiki](https://github.com/bitcoin/bips/blob/master/bip-0122.mediawiki)
- **IPFS Documentation**: [https://docs.ipfs.io/](https://docs.ipfs.io/)
- **Solidity Documentation**: [https://docs.soliditylang.org/](https://docs.soliditylang.org/)
- **Foundry Book**: [https://book.getfoundry.sh/](https://book.getfoundry.sh/)

## License

This project is licensed under the **MIT License** - see the [LICENSE](LICENSE) file for details.

The EIP-2678 specification is dual-licensed under CC0-1.0 and MIT.

## Contributing

Contributions are welcome! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feat/amazing-feature`)
3. Commit your changes (`git commit -m 'feat: add amazing feature'`)
4. Push to the branch (`git push origin feat/amazing-feature`)
5. Open a Pull Request

### Development Guidelines

- Follow Solidity style guide
- Write comprehensive tests (>80% coverage)
- Document all public functions with NatSpec
- Use conventional commit messages
- Ensure all tests pass before submitting

### Testing
```bash
# Run tests
forge test

# Run with coverage
forge coverage

# Format code
forge fmt
```

## Citation

Please cite this document as:

**Original EIP Authors:**
> g. nicholas d'andrea (@gnidan), Piper Merriam (@pipermerriam), Nick Gheorghita (@njgheorghita), Christian Reitwiessner (@chriseth), Ben Hauser (@iamdefinitelyahuman), Bryant Eisenbach (@fubuloubu), "ERC-2678: Revised Ethereum Smart Contract Packaging Standard (EthPM v3)," Ethereum Improvement Proposals, no. 2678, May 2020. [Online serial]. Available: https://eips.ethereum.org/EIPS/eip-2678.

**Implementation:**
> EIPs-CodeLab, "ERC-2678 Solidity Implementation," 2024. [Online]. Available: https://github.com/EIPs-CodeLab/ERC-2678

---

## Acknowledgments

- Ethereum Foundation for the EIP process
- EthPM working group for the specification
- Foundry team for development tools
- All contributors to this implementation


---

*Translating EIPs into Code*