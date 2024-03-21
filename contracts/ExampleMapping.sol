// SPDX-License-Identifier: MIT  

pragma solidity 0.8.15;  

contract ExampleMapping {  


    mapping(uint => bool) public myMapping;                      // Tam sayılarla (unsigned integer) dizinlenen boole değerleri depolar
    mapping(address => bool) public myAddressMapping;           // Ethereum adresleriyle dizinlenen boole değerleri depolar
    mapping(uint => mapping(uint => bool)) public uintUintBoolMapping; // Daha karmaşık veri yapıları için iç içe geçmiş eşlemleri depolar

    // myMapping'de bir boole değeri atamak için fonksiyon:
    function setValue(uint _index) public {
        myMapping[_index] = true;  // myMapping içindeki _index anahtarına true değerini atar
    }

    // Çağırının adresine bağlı boole değerini true olarak ayarlamak için fonksiyon:
    function setMyAddressToTrue() public {
        myAddressMapping[msg.sender] = true;  // myAddressMapping içindeki msg.sender anahtarına true değerini atar
    }

    // uintUintBoolMapping'de iç içe geçmiş eşleme içinde bir değer atamak için fonksiyon:
    function setUintBoolMapping(uint _key1, uint _key2, uint _key3, bool _value) public {
        uintUintBoolMapping[_key1][_key2] = _value;  // _key1 konumundaki iç içe geçmiş eşleme içinde _key2 anahtarına _value değerini atar
    }
}

//setValue: myMapping mapping'ine bir değer atar.
//setMyAddressToTrue: myAddressMapping mapping'ine msg.sender'ı anahtar olarak bir değer atar.
//setuintBoolMapping: uintUintBoolMapping içindeki iç içe geçmiş mapping'e bir değer atar
