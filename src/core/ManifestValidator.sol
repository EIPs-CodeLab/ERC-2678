// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title ManifestValidator
/// @notice Validates EthPM v3 manifest structure and naming conventions (EIP-2678)
library ManifestValidator {
    
    /// @notice Validate contract name matches EIP-2678 regex: ^[a-zA-Z_$][a-zA-Z0-9_$]{0,255}$
    /// @param name Contract name to validate
    /// @return valid True if name is valid
    function isValidContractName(string memory name) internal pure returns (bool) {
        bytes memory nameBytes = bytes(name);
        
        // Must have at least 1 character, max 256
        if (nameBytes.length == 0 || nameBytes.length > 256) {
            return false;
        }
        
        // First character must be: a-z, A-Z, _, $
        bytes1 first = nameBytes[0];
        bool validFirst = (first >= 0x61 && first <= 0x7A) ||  // a-z
                          (first >= 0x41 && first <= 0x5A) ||  // A-Z
                          (first == 0x5F) ||                    // _
                          (first == 0x24);                      // $
        
        if (!validFirst) {
            return false;
        }
        
        // Rest can be: a-z, A-Z, 0-9, _, $
        for (uint256 i = 1; i < nameBytes.length; i++) {
            bytes1 char = nameBytes[i];
            bool validChar = (char >= 0x61 && char <= 0x7A) ||  // a-z
                             (char >= 0x41 && char <= 0x5A) ||  // A-Z
                             (char >= 0x30 && char <= 0x39) ||  // 0-9
                             (char == 0x5F) ||                   // _
                             (char == 0x24);                     // $
            
            if (!validChar) {
                return false;
            }
        }
        
        return true;
    }
    
    /// @notice Validate package name matches EIP-2678: lowercase, numbers, hyphens only
    /// @param name Package name to validate
    /// @return valid True if name is valid
    function isValidPackageName(string memory name) internal pure returns (bool) {
        bytes memory nameBytes = bytes(name);
        
        if (nameBytes.length == 0) {
            return false;
        }
        
        for (uint256 i = 0; i < nameBytes.length; i++) {
            bytes1 char = nameBytes[i];
            
            bool isLowercase = (char >= 0x61 && char <= 0x7A); // a-z
            bool isNumber = (char >= 0x30 && char <= 0x39);    // 0-9
            bool isHyphen = (char == 0x2D);                     // -
            
            if (!isLowercase && !isNumber && !isHyphen) {
                return false;
            }
        }
        
        return true;
    }
    
    /// @notice Validate contract alias matches EIP-2678: <contract-name> or <contract-name><identifier>
    /// @param contractAlias Contract alias to validate
    /// @return valid True if alias is valid
    function isValidContractAlias(string memory contractAlias) internal pure returns (bool) {
        bytes memory aliasBytes = bytes(contractAlias);
        if (aliasBytes.length == 0 || aliasBytes.length > 256) {
        return false;
        }
    
        // Alias can contain: a-z, A-Z, 0-9, -, _
        for (uint256 i = 0; i < aliasBytes.length; i++) {
            bytes1 char = aliasBytes[i];
            
            bool isLetter = (char >= 0x61 && char <= 0x7A) || (char >= 0x41 && char <= 0x5A);
            bool isNumber = (char >= 0x30 && char <= 0x39);
            bool isHyphen = (char == 0x2D);
            bool isUnderscore = (char == 0x5F);
            
            if (!isLetter && !isNumber && !isHyphen && !isUnderscore) {
                return false;
            }
        }
    
        return true;
}
    
    /// @notice Validate manifest version is "ethpm/3"
    /// @param version Manifest version string
    /// @return valid True if version is correct
    function isValidManifestVersion(string memory version) internal pure returns (bool) {
        return keccak256(bytes(version)) == keccak256(bytes("ethpm/3"));
    }
    
    /// @notice Check if key is forbidden in v3 manifest
    /// @param key Manifest key to check
    /// @return forbidden True if key is forbidden
    function isForbiddenKey(string memory key) internal pure returns (bool) {
        // "manifest_version" is forbidden in v3, must use "manifest"
        return keccak256(bytes(key)) == keccak256(bytes("manifest_version"));
    }
}