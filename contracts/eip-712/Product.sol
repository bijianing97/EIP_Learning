// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "./IProduct.sol";
import "@openzeppelin/contracts/utils/cryptography/EIP712.sol";
import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

// eip 712 "\x19\x01" ‖ domainSeparator ‖ hashStruct(message)  “‖” is for connection
contract Product is EIP712, IProduct {
    event SignerOut(address indexed signer);

    bytes32 constant PERSON_TYPE_HASH =
        keccak256("Persion(string name,address wallet)");
    bytes32 constant MAIL_TYPE_HASH =
        keccak256(
            "Mail(Person from,Person to,string contents)Person(string name,address wallet)"
        );

    constructor(
        string memory _name,
        string memory _version
    ) EIP712(_name, _version) {}

    function hash(Person memory person) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    PERSON_TYPE_HASH,
                    keccak256(bytes(person.name)),
                    person.wallet
                )
            );
    }

    function hash(Mail memory mail) internal pure returns (bytes32) {
        return
            keccak256(
                abi.encode(
                    MAIL_TYPE_HASH,
                    hash(mail.from),
                    hash(mail.to),
                    keccak256(bytes(mail.contents))
                )
            );
    }

    function verify(
        Mail memory mail,
        bytes memory signature
    ) external override {
        bytes32 digest = _hashTypedDataV4(hash(mail));
        address signer = ECDSA.recover(digest, signature);
        emit SignerOut(signer);
        require(signer == msg.sender, "Not same, no sender");
    }
}
