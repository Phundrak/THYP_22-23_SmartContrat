pragma solidity ^0.4.19;

import "./ownable.sol";
import "./safemath.sol";

/// @title Contrat de création de tickets à un événement
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
contract Ticket is Ownable {
    using SafeMath for uint256;

    event NewTicket(uint ticketId, string eventName, uint32 seat);

    struct Ticket {
        string eventName;
        uint32 seat;
        uint16 price;
        bool used;
    };

    Ticket[] public tickets;

    mapping (uint => address) public ticketToOwner;
    mapping (address => uint) ownerTicketCount;

    /// @title Création d’un nouveau ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    function _createNewTicket(string _event, uint32 _seat, uint16 _price) internal {
        uint id = tickets.push(Ticket(_event, _id, _seat, _price, false)) - 1;
        ticketToOwner[id] = msg.sender;
        ownerTicketCount[msg.sender] = ownerTicketCount[msg.sender].add(1);
        NewTicket(id, _event, _seat);
    }

    /// @title Création d’un nouveau ticket par le propriétaire du contrat
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    function createTicket(string _event, uint32 _seat, uint16 _price) public onlyOwner {
        _createNewTicket(_event, _seat, _price);
    }
}
