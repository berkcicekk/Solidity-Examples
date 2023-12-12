// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

//@0xberkelfreud

contract ExampleViewPure {
   
   uint public myStorageVariable;

    function getMyStorageVariable() public view returns(uint) {
        return myStorageVariable;
    }

    function getAddition(uint a, uint b) public pure returns(uint) {
        return a+b;
    }
}