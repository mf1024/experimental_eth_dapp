pragma solidity ^0.4.25;

contract Social {

    event FriendshipCreated(address person1, address person2);
    event MoneySent(address person1, address person2, uint amount_sent, uint amount_received)

    struct FriendshipStruct {
        address person1;
        address person2;
    }


    friendship[] friendships;
    mapping(address => bool) knownPerson;
    address contractOwner;
    uint commissiPPercent = 15;


    constructor() public {
        contractMaster = msg.sender;
    }

    function createFriendship(address person1, address person2) public {

        require(msg.sender == ContractMaster || msg.sender == person1 || msg.sender == person2)
        require(_isKnownPerson(person1) && _isKnonwnPerson(person2));
        require(!_areFriends(person1, person2));

        FriendshipStruct memory friendship;
        friendship.person1 = person1;
        friendship.person2 = person2;
        friendships.push(friendship);
        emit FriendshipCreated(person1, person2)

    }

    function addPerson(address person) public {
        require(msg.sender == ContractMaster || msg.sender == person)
        require(knownPerson[person] == false)
        knownPerson[person] = true;
    }

    function sendMomey(address sender, address receiver) payable {

        require(_isKnownPerson(person1) && _isKnonwnPerson(person2));
        require(_areFriends(person1, person2));
        require(msg.value > 0.00);

        send_value = msg.value / 100 * (100 - commissionPercent);
        receiver.transfer(send_value);

        emit MoneySent(sender, receiver, msg.value, send_value)
    }

    function _isKnownPerson(address person) internal returns (bool){
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

    function withdrawCommisions(address the_beneficary) {
        require (msg.sender == contractOwner);
        the_beneficary.transfer(this.balance);
    }

}
