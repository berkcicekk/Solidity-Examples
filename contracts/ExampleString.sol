//SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

//@0xberkelfreud

contract ExampleStrings {

    string public myString = "Hello World"; 
    bytes public myBytes = "Hello World";

    // # String'ler aslında UTF-8 kodlamasında saklanan byte'lardır.
    // # Byte'lar, string'lerden daha esnektir ve herhangi bir veri türünü saklayabilir.
    // # String'ler, byte'lara göre daha güvenlidir çünkü UTF-8 kodlaması veri bütünlüğünü sağlar.


    function setMyString(string memory _myString) public {
        myString = _myString;
    }

    function compareTwoStrings(string memory _myString) public view returns(bool) {
        return keccak256(abi.encodePacked(myString)) == keccak256(abi.encodePacked(_myString));
    }

    function getBytesLength() public view returns(uint) {
        return myBytes.length;
    }

}