// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./ticketfactory.sol";

/// @title Contrat de gestion des tickets
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
contract TicketManagement is SmartTicket {

    /// @param _ticketId Identifiant du ticket
    modifier onlyOwnerOf(uint _ticketId) {
        require(msg.sender == ticketToOwner[_ticketId]);
        _;
    }

    /// @param _ticketId Identifiant du ticket
    /// @dev Vérifie que le ticket n’est pas utilisé afin de pouvoir appeler une fonction.
    modifier notUsed(uint _ticketId) {
        require(tickets[_ticketId].used == false);
        _;
    }

    /// @notice Le propriétaire d’un ticket peut choisir de modifier son prix s’il souhaite le revendre par la suite.
    /// @param _ticketId Identifiant du ticket dont on souhaite modifier le prix
    /// @param _newPrice Nouveau prix du ticket
    function changePrice(uint _ticketId, uint16 _newPrice) external onlyOwnerOf(_ticketId) notUsed(_ticketId) {
        Ticket storage myTicket = tickets[_ticketId];
        myTicket.price = _newPrice;
    }

    /// @notice Permet au propriétaire du contrat de retirer l’argent gagné avec les frais d’échange de tickets.
    function ownerWithdraw() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }
}
