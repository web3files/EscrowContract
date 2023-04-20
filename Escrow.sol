pragma solidity ^0.8.0;

contract Escrow {
    address payable public buyer;
    address payable public seller;
    address payable public arbiter;
    uint public amount;
    bool public approvedByBuyer;
    bool public approvedBySeller;

    constructor(address payable _buyer, address payable _seller, address payable _arbiter, uint _amount) {
        buyer = _buyer;
        seller = _seller;
        arbiter = _arbiter;
        amount = _amount;
    }

    function approveByBuyer() public {
        require(msg.sender == buyer);
        approvedByBuyer = true;
    }

    function approveBySeller() public {
        require(msg.sender == seller);
        approvedBySeller = true;
    }

    function payout() public {
        require(approvedByBuyer && approvedBySeller);
        seller.transfer(amount);
    }

    function refund() public {
        require(!approvedByBuyer || !approvedBySeller);
        if (msg.sender == arbiter) {
            buyer.transfer(amount);
        } else if (msg.sender == buyer) {
            buyer.transfer(amount);
        } else if (msg.sender == seller) {
            seller.transfer(amount);
        }
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}
