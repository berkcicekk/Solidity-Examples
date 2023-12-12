// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

//@0xberkelfreud

contract ExampleMsgSender {
   
    address public someAddress;
    // Bir Ethereum adresini (address) depolayan genel bir değişken tanımlanır.

    function updateSomeAddress() public {
        someAddress = msg.sender;
    }
    // Bu fonksiyon, işlemi başlatan Ethereum adresini (msg.sender) 
    // kullanarak "someAddress" değişkenini günceller.

}

