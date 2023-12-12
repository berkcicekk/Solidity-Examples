// SPDX-License-Identifier: GPL-3.0
pragma solidity 0.8.14;

//@0xberkelfreud

contract ExampleConstructor {

    address public myAddress;

    constructor(address _someAddress){ 
        // Kontrat oluşturulduğunda bir kez çalışır ve başlangıç değerini atar.
        myAddress = _someAddress;
    }

    function setMyaddress(address _myAdress) public {
        // `_myAdress` adında bir `address` türünde parametre alan bir fonksiyon tanımlanır.
        // Bu fonksiyon, `_myAdress` parametresini alır ve `myAddress` değişkenine atar.
        myAddress = _myAdress;
    }

    function setMyaddressToMsgSender() public {
        // `setMyaddressToMsgSender` adında bir fonksiyon tanımlanır.
        // Bu fonksiyon, çağıranın (msg.sender) adresini alır ve `myAddress` değişkenine atar.
        myAddress = msg.sender;
    }
}
