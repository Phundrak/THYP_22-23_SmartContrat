pragma solidity ^0.4.19;

import "./ticketfactory.sol";

/// @title Contrat de gestion des tickets
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
contract TicketManagement is Ticket {

    /// @title Restreint l’accès à une fonction au propriétaire d’un ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param ticketId Identifiant du ticket
    modifier onlyOwnerOf(uint _ticketId) {
        require(msg.sender == ticketToOwner[_tickedId]);
        _;
    }

    /// @title Changement du prix d’un ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @notice Le propriétaire d’un ticket peut choisir de modifier son prix s’il souhaite le revendre par la suite.
    /// @param ticketId Identifiant du ticket dont on souhaite modifier le prix
    /// @param newPrice Nouveau prix du ticket
    function changePrice(uint _ticketId, uint16 _newPrice) external onlyOwnerOf(_ticketId) {
        Ticket storage myTicket = tickets[_ticketId];
        myTicket.price = _newPrice;
    }

    /// @title Retirer l’argent stocké sur le contrat
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @notice Permet au propriétaire du contrat de retirer l’argent gagné avec les frais d’échange de tickets.
    function ownerWithdraw() external onlyOwner {
        owner.transfer(this.balance);
    }
}
