//SPDX-License-Identifier:MIT
pragma solidity ^0.8.9;

contract Bank {
    address[] users;
    mapping(address => uint) public balances;
    address private immutable owner;

    //events
    event EmitFall(bytes32);
    event receiveE(bytes32);

    modifier onlyOwner() {
        require(msg.sender == owner, "Unauthrorized Caller");
        _;
    }

    modifier checkValue(uint val) {
        require(val > 0, "Not Enough ETH");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    receive() external payable {
        deposit();
    }

    fallback() external payable {
        emit EmitFall("Fallback emitted");
        deposit();
    }

    function deposit() public payable checkValue(msg.value) returns (uint) {
        users.push(msg.sender);

        balances[msg.sender] += msg.value;

        return balances[msg.sender];
    }

    function withdraw(uint _amount)
        external
        checkValue(_amount)
        returns (uint)
    {
        //effects
        balances[msg.sender] -= _amount;
        //interaction
        payable(msg.sender).transfer(_amount);

        return balances[msg.sender];
    }

    function getBalance() external view returns (uint) {
        return balances[msg.sender];
    }
}
