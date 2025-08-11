// SPDX-License-Identifier: MIT
pragma solidity 0.8.24; // Stating version of solidity compiler to be used

// pragma solidity ^0.8.18; // Stating at least this version to be used
// pragma solidity >=0.8.18 <0.9.0 // Range of version

contract SimpleStorage {
    // bool hasFavorite=true;
    // int256 favoriteNumber=88;
    // string favoriteNumberInText="eighty-eight"; // basically wrapper on bytes
    // address myAddress = 0x5Cd9142693Ad5CE14033262cb90833ADd71c6580;
    // bytes32 favoriteBytes32 = "cat"; // represented as hex 0x2aser25fs

    uint256 public myFavoriteNumber; // default number 0
    // uint256[] listFavNumbers;
    Person public myFriend = Person({favoriteNumber: 7, name: "Pat"});

    //dynamic array
    Person[] public listOfPeople;

    //static
    Person[2] public listOfTwoPeople;

    mapping(string => uint256) public nameToFavoriteNumber;

    //Struct automatically zero-indexes the variables
    struct Person {
        uint256 favoriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public {
        myFavoriteNumber = _favoriteNumber;
        myFavoriteNumber += 1;
    }

    function addPersonToList(
        uint256 _favoriteNumber,
        string memory _name
    ) public {
        //    Person memory newPerson = Person({favoriteNumber: _favoriteNumber, name: _name});
        //     listOfPeople.push(newPerson);
        listOfPeople.push(
            Person({favoriteNumber: _favoriteNumber, name: _name})
        );
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    //calldata and memory tell it to store it in thos places respectively
    //these are temporary stores and get destroyed afterwards
    //calldata variables are temporary variables that cannot be modified
    //memory variables are temporary variables that can be modified
    //storage variables are permament variables that can be modified (myFavoriteNumber was converted to storage implicitly)

    // view - only reading state, not changing it
    // BY adding view we disallow any modification of state
    function retrieve() public view returns (uint256) {
        return myFavoriteNumber;
    }

    //pure- disallows even reading the state
    function pureRetrieve() public pure returns (uint256) {
        return 8;
    }

    //view and pure functions dont cost gas by themselves
    //But if a different function calls them then they do
}
