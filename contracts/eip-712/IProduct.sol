// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IProduct {
    struct Person {
        string name;
        address wallet;
    }

    struct Mail {
        Person from;
        Person to;
        string contents;
    }

    function verify(Mail memory mail, bytes memory signature) external;
}
