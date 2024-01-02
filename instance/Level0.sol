// SPDX-License-Identifier: MIT
// For this level I used an interface because the contract code was not available before clearing the level

pragma solidity ^0.8.16;

interface ILevel0 {
    function password() external returns (string memory);

    function authenticate(string memory passkey) external;

    function getCleared() external returns (bool);
}
