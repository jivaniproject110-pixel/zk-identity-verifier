```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/ReentrancyGuardUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/math/SafeMathUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/utils/AddressUpgradeable.sol";

contract ZKIdentityVerifier is Initializable, OwnableUpgradeable, ReentrancyGuardUpgradeable {
    using SafeMathUpgradeable for uint256;
    using AddressUpgradeable for address;

    // Mapping of user addresses to their verification status
    mapping(address => bool) public verifiedUsers;

    // Mapping of user addresses to their age
    mapping(address => uint256) public userAges;

    // Flag to indicate if the contract is paused
    bool public paused;

    // Event emitted when a user is verified
    event UserVerified(address indexed user, uint256 age);

    // Event emitted when a user's verification status is updated
    event VerificationStatusUpdated(address indexed user, bool verified);

    // Event emitted when the contract is paused or unpaused
    event ContractPaused(bool paused);

    // Event emitted when the owner is updated
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract
     */
    function initialize() public initializer {
        __Ownable_init();
        __ReentrancyGuard_init();
    }

    /**
     * @dev Verifies a user's age using a zero-knowledge proof
     * @param _user The address of the user to verify
     * @param _age The age of the user
     * @param _proof The zero-knowledge proof
     */
    function verifyUser(address _user, uint256 _age, bytes calldata _proof) external nonReentrant {
        require(!paused, "Contract is paused");
        require(_user != address(0), "Invalid user address");
        require(_age > 0, "Invalid age");

        // Verify the zero-knowledge proof
        bool verified = verifyProof(_user, _age, _proof);
        require(verified, "Invalid proof");

        // Update the user's verification status
        verifiedUsers[_user] = true;
        userAges[_user] = _age;

        emit UserVerified(_user, _age);
        emit VerificationStatusUpdated(_user, true);
    }

    /**
     * @dev Updates a user's verification status
     * @param _user The address of the user to update
     * @param _verified The new verification status
     */
    function updateVerificationStatus(address _user, bool _verified) external onlyOwner {
        require(_user != address(0), "Invalid user address");

        verifiedUsers[_user] = _verified;

        emit VerificationStatusUpdated(_user, _verified);
    }

    /**
     * @dev Pauses or unpauses the contract
     * @param _paused The new pause status
     */
    function setPaused(bool _paused) external onlyOwner {
        paused = _paused;

        emit ContractPaused(_paused);
    }

    /**
     * @dev Verifies a zero-knowledge proof
     * @param _user The address of the user
     * @param _age The age of the user
     * @param _proof The zero-knowledge proof
     * @return bool Whether the proof is valid
     */
    function verifyProof(address _user, uint256 _age, bytes calldata _proof) internal pure returns (bool) {
        // TO DO: implement the zero-knowledge proof verification logic using Circom circuits and Groth16 proofs
        // For demonstration purposes, this function always returns true
        return true;
    }
}
```