pragma solidity ^0.5.16;

contract Social {

    event FriendshipCreated(address person1, address person2);
    event MoneySent(address person1, address person2, uint amount_sent, uint amount_received);

    struct FriendshipStruct {
        address person1;
        address person2;
    }


    FriendshipStruct[] friendships;
    mapping(address => bool) knownPerson;
    address contractOwner;
    uint comissionPercent = 15;


    constructor() public {
        contractOwner = msg.sender;
    }

    function createFriendship(address person1, address person2) public {

        require(_isKnownPerson(person1) && _isKnownPerson(person2), "To interact with the app both of the persons must be added to it with addPerson(address) function!");
        require(msg.sender == contractOwner || msg.sender == person1 || msg.sender == person2, "To create friendship, you must be one of the persons.");
        require(!_areFriends(person1, person2), "They already friends!");

        FriendshipStruct memory friendship;
        friendship.person1 = person1;
        friendship.person2 = person2;
        friendships.push(friendship);
        emit FriendshipCreated(person1, person2);

    }

    function addPerson(address person) public {
        require(msg.sender == contractOwner || msg.sender == person, "You can add only yourself!");
        require(knownPerson[person] == false, "You are already added to the app!");
        knownPerson[person] = true;
    }

    function sendMoney(address payable receiver) payable public {

        require(_isKnownPerson(msg.sender), "You must be added to the app to interact with it! Use addPerson(address) function!");
        require(_isKnownPerson(receiver), "Receiver of the money must be added to the app before you can send him/her a money!");
        require(_areFriends(msg.sender, receiver), "You can send money only to your friends!");
        require(msg.value > 0.00);

        uint send_value = msg.value / 100 * (100 - comissionPercent);
        receiver.transfer(send_value);

        emit MoneySent(msg.sender, receiver, msg.value, send_value);
    }

    function _isKnownPerson(address person) internal view returns (bool){
        return knownPerson[person];
    }

    function _areFriends(address person1, address person2) internal view returns (bool) {
        uint friendshipsArrayLen = friendships.length;
        bool are_friends = false;
        for (uint i=0; i<friendshipsArrayLen; i++) {
            if (friendships[i].person1 == person1 && friendships[i].person2 == person2) are_friends = true;
            if (friendships[i].person1 == person2 && friendships[i].person2 == person1) are_friends = true;
        }
    
        return are_friends;
    }

    function withdrawCommisions(address payable the_beneficary) public {
        require (msg.sender == contractOwner);
        the_beneficary.transfer(address(this).balance);
    }

}
