// SPDX-License-Identifier: MIT

pragma solidity 0.8.14;

//@0xberkelfreud

contract ExampleUint {
    // Bir Solidity akıllı kontratının başlangıcını belirtir. "ExampleUint" adında bir kontrat oluşturuluyor.

    uint256 public myUint;
    uint8 public myUint8 = 250;
    int public myInt = -10 ;
    // İki değişkeni tanımlar: Birincisi, "myUint" adında bir `uint256` türünde genel bir değişken, 
    // ikincisi, "myUint8" adında bir `uint8` türünde genel bir değişken ve başlangıç değeri 250'dir.

    function setMyUint(uint256 _myUint) public {
        myUint = _myUint;
    }
    // "myUint" değişkenini ayarlamak için kullanılan fonksiyon. 
    // "_myUint" adında bir parametre alır ve bu değeri "myUint" değişkenine atar.

    function increementUint8() public {
        myUint8++;
    }

    function incrementInt() public {
            myInt++;
    }
    

}
