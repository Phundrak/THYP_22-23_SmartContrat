pragma solitity ^0.4.19;

import "./ticketmanagement.sol";
import "./erc721.sol";
import "./safemath.sol";

/// @title Contrat de gestion de propriété des tickets
/// @author Lucien Cartier-Tilet <lucien@phundrak.com>
/// @dev Conforme aux spécificités provisoires de l’implémentation ERC721
contract TicketOwnership is TicketManagement, ERC721 {
    using SafeMath for uint256;

    mapping (uint => address) ticketApprovals;

    uint transferFee = 0.0005 ether;

    /// @title Changement des frais d’échange de tickes
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param fee Nouveaux frais en ether
    /// @dev uniquement accessible au propriétaire du contrat
    function setTransferFee(uint _fee) external payable onlyOwner {
        transferFee = _fee;
    }

    /// @title Connaître la quantité de tickets détenus par une personne
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param owner Compte de la personne
    /// @return balance Nombre de tickets détenus
    function balanceOf(address _owner) public view returns (uint256 _balance) {
        return ownerTicketCount[_owner];
    }

    /// @title Propriétaire d’un ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param tokenId Identifiant du ticket
    /// @return owner Adresse du propriétaire du ticket
    /// @dev tokenId est l’index du ticket dans tickets
    function ownerOf(uint256 _tokenId) public view returns (address _owner) {
        return ticketToOwner[_tokenId];
    }

    /// @title Transfert d’un ticket d’une personne à une autre
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param from Propriétaire original
    /// @param to Nouveau propriétaire
    /// @param tokenId Identifiant du ticket
    /// @dev Fonction interne, suppose que le transfert a déjà été effectué
    function _transfer(address _from, address _to, uint256 _tokenId) private {
        ownerTicketCount[_to] = ownerTicketCount[_to].add(1);
        ownerTicketCount[msg.sender] = ownerTicketCount[msg.sender].sub(1);
        ticketToOwner[_tokenId] = _to;
        Transfer(_from, _to, _tokenId);
    }

    /// @title Approbation de la part du propriétaire pour qu’une personne acquière un ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param to Personne pouvant acquérir le ticket
    /// @param tokenId Ticket pouvant changer de mains
    /// @notice Seul le propriétaire d’un ticket peut approuver son transfert
    function approve(address _to, uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        ticketApprovals[_tokenId] = _to;
        Approvals(msg.sender, _to, _tokenId);
    }

    /// @title Achat d’un ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param tokenId Identifiant du ticket pouvant être acheté
    /// @notice Seule une personne ayant été approuvée par le propriétaire du ticket peut l’acheter. Elle doit transférer avec l’appel de cette fonction le prix du ticket.
    function takeOwnership(uint256 _tokenId) public payable {
        require(ticketApprovals[_tokenId] == msg.sender);
        require(msg.value == tickets[_tokenId].price);
        address owner = ownerOf(_tokenId);
        owner.transfer(msg.value - transferFee);
        _transfer(owner, msg.sender, _tokenId);
    }

    /// @title Annulation du transfert du ticket
    /// @author Lucien Cartier-Tilet <lucien@phundrak.com>
    /// @param tokenId Identifiant du ticket dont le transfert est annulé
    /// @notice Une annulation de transfert n’est pas payante. Elle retire juste l’opportunité à l’acheteur potentiel de l’acheter.
    function cancelOwnership(uint256 _tokenId) public onlyOwnerOf(_tokenId) {
        require(ticketApprovals[_tokenId] == msg.sender);
        address owner = ownerOf(_tokenId);
        ticketApprovals[_tokenId] = owner;
    }
}
