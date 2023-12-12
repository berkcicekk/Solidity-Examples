// SPDX-License-Identifier: MIT

pragma solidity 0.8.15;

 //@0xberkelfreud

contract ExampleAddress {

    address public someAddress;
    

    function setSomeAddress(address _someAddress) public {
        someAddress = _someAddress;
    }
        // # "setSomeAddress" adında bir fonksiyon tanımlanır. Bu fonksiyon, "_someAddress" adında bir Ethereum adresi alır 
        // # ve bu adresi "someAddress" değişkenine atar.

    function getAddressBalance() public view returns(uint) {
        // # "getAddressBalance" adında bir fonksiyon tanımlanır. Bu fonksiyon, "someAddress" değişkeninin bakiyesini 
        // # görüntülemek için kullanılır ve bir tamsayı değeri döndürür.

        return someAddress.balance;
    }
}
// Kontrat tanımının sonunu belirtir.
