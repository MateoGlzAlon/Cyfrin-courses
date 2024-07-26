//SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SimpleStorage {
    uint256 myFavoriteNumber = 13;

    uint256[] listOfFavoriteNumbers;

    struct Person {
        uint256 favNumber;
        string name;
    }

    //Person public myFriend = Person(25, "Jorge");
    //Person public myFriend2 = Person({favNumber: 7, name: "Rafa"}); 

    Person[] public listOfPeople;


    mapping (string => uint256) public nameToFavNumber;

    function store(uint256 newFavoriteNumber) public virtual {
        myFavoriteNumber = newFavoriteNumber;
    }

    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    function addPerson(uint256 _favNumber, string memory _name) public {
        Person memory persona = Person(_favNumber, _name);
        listOfPeople.push(persona);
        nameToFavNumber[_name] = _favNumber;
    }
}
