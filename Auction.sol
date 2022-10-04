//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract allowanceContract {

    address public owner;
    mapping(address => uint) public allowances;

    event log(string _description, address _to, uint _amt);
    
    receive() external payable {}

    constructor() {
        owner = msg.sender;
    }
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can access");
        _;
    }

    modifier ownerOrAllowed(uint _amt) {
        require(isOwner() || allowances[msg.sender] >= _amt, "Not allowed");
        _;
    }

    function isOwner() private view returns(bool) {
        if(msg.sender == owner) return true;
        else return false;
    }

    function addAllowance(address _to, uint _amt) public onlyOwner {
        allowances[_to] += _amt;
    }

    function withdrawMoney(address payable _to, uint _amt, string memory _description) public ownerOrAllowed(_amt) {
        require(address(this).balance >= _amt, "Don't have enough funds");
        emit log(_description, _to, _amt);
        if(isOwner() == false){
            allowances[_to] -= _amt;
        }
        _to.transfer(_amt);
    }

}