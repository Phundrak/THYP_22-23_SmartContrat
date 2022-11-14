// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title Contrat de création de tickets à un événement
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
contract SmartTicket is Ownable {
    using SafeMath for uint256;

    event NewTicket(uint ticketId, string eventName, uint32 seat);

    struct Ticket {
        string eventName;
        uint32 seat;
        uint16 price;
        bool used;
    }

    Ticket[] public tickets;

    mapping (uint => address) public ticketToOwner;
    mapping (address => uint) ownerTicketCount;

    function _createNewTicket(string memory _event, uint32 _seat, uint16 _price) internal {
        tickets.push(Ticket(_event, _seat, _price, false));
        uint id = tickets.length - 1;
        ticketToOwner[id] = msg.sender;
        ownerTicketCount[msg.sender] = ownerTicketCount[msg.sender].add(1);
        NewTicket(id, _event, _seat);
    }

    function createTicket(string memory _event, uint32 _seat, uint16 _price) public onlyOwner {
        _createNewTicket(_event, _seat, _price);
    }
}
