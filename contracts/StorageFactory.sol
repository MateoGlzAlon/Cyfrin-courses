//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {SimpleStorage} from "./SimpleStorage.sol";

contract StorageFactory {
    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {

        SimpleStorage newsimpleStorageContract = new SimpleStorage();
        listOfSimpleStorageContracts.push(newsimpleStorageContract);

    } 

    function sfStore (uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {

        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        mySimpleStorage.store(_newSimpleStorageNumber);
    }

    function sfGet (uint _simpleStorageIndex) public view returns(uint256){

        SimpleStorage mySimpleStorage = listOfSimpleStorageContracts[_simpleStorageIndex];
        return mySimpleStorage.retrieve();
    }
}
