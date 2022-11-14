// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.8.0 <0.9.0;

import "./ticketmanagement.sol";
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

/// @title Contrat de gestion de propriété des tickets
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
/// @dev Conforme aux spécificités provisoires de l’implémentation ERC721
abstract contract TicketOwnership is TicketManagement, ERC721 {
    using SafeMath for uint256;

    mapping (uint => address) ticketApprovals;

    uint transferFee = 0.0005 ether;

    /// @param _fee Nouveaux frais en ether
    /// @dev uniquement accessible au propriétaire du contrat
    function setTransferFee(uint _fee) external payable onlyOwner {
        transferFee = _fee;
    }

    /// @param _owner Compte de la personne
    /// @return _balance Nombre de tickets détenus
    function balanceOf(address _owner) public override view returns (uint256 _balance) {
        return ownerTicketCount[_owner];
    }

    /// @param _tokenId Identifiant du ticket
    /// @return _owner Adresse du propriétaire du ticket
    /// @dev tokenId est l’index du ticket dans tickets
    function ownerOf(uint256 _tokenId)
        public
        override
        view
        returns (address _owner)
    {
        return ticketToOwner[_tokenId];
    }

    /// @param _from Propriétaire original
    /// @param _to Nouveau propriétaire
    /// @param _tokenId Identifiant du ticket
    /// @dev Fonction interne, suppose que le transfert a déjà été effectué
    function _transfer(
        address _from,
        address _to,
        uint256 _tokenId
    ) override internal notUsed(_tokenId) {
        ownerTicketCount[_to] = ownerTicketCount[_to].add(1);
        ownerTicketCount[msg.sender] = ownerTicketCount[msg.sender].sub(1);
        ticketToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    /// @param _to Personne pouvant acquérir le ticket
    /// @param _tokenId Ticket pouvant changer de mains
    /// @notice Seul le propriétaire d’un ticket peut approuver son transfert
    function approve(address _to, uint256 _tokenId)
        override
        public
        notUsed(_tokenId)
        onlyOwnerOf(_tokenId)
    {
        ticketApprovals[_tokenId] = _to;
        Approval(msg.sender, _to, _tokenId);
    }

    /// @param _tokenId Identifiant du ticket pouvant être acheté
    /// @notice Seule une personne ayant été approuvée par le propriétaire du ticket peut l’acheter. Elle doit transférer avec l’appel de cette fonction le prix du ticket.
    function takeOwnership(uint256 _tokenId) public payable notUsed(_tokenId) {
        require(ticketApprovals[_tokenId] == msg.sender);
        require(msg.value == tickets[_tokenId].price);
        address payable owner = payable(ownerOf(_tokenId));
        owner.transfer(msg.value - transferFee);
        _transfer(owner, msg.sender, _tokenId);
    }

    /// @param _tokenId Identifiant du ticket dont le transfert est annulé
    /// @notice Une annulation de transfert n’est pas payante. Elle retire juste l’opportunité à l’acheteur potentiel de l’acheter.
    function cancelOwnership(uint256 _tokenId) public onlyOwnerOf(_tokenId) notUsed(_tokenId) {
        require(ticketApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        ticketApprovals[_tokenId] = owner;
    }
}
