pragma solidity ^0.8.0;

contract ContratBail {
    string public nomContrat = "Contrat de Bail avec Blockchain";
    
    // Déclaration des acteurs
    address public proprietaire;
    address public locataire;

    event LoyerPaye(address locataire, uint montant);

    uint public loyer; // Montant du loyer en wei (la plus petite unité de l'Ether)
    bool public loyerPaye; // Pour savoir si c'est payé 

    // On modifie le constructeur pour accepter un argument
    constructor(uint _montantLoyer) {
        proprietaire = msg.sender;
        loyer = _montantLoyer; // On fixe le loyer au déploiement
        loyerPaye = false;
    }

    function definirLocataire(address _locataire) public {
        // On vérifie que c'est bien le propriétaire qui appelle la fonction
        require(msg.sender == proprietaire, "Seul le proprietaire peut designer le locataire");
        locataire = _locataire;
    }

    function payerLoyer() public payable {
        require(msg.sender == locataire, "Seul le locataire peut payer");
        require(msg.value == loyer, "Le montant doit correspondre au loyer");
        require(loyerPaye == false, "Loyer deja paye");

        loyerPaye = true;
        emit LoyerPaye(msg.sender, msg.value); // On "émet" le reçu ici 
    }


    function retirerLoyer() public {
        require(msg.sender == proprietaire, "Seul le proprietaire peut retirer");
        require(loyerPaye == true, "Le loyer n'a pas encore ete paye");

        uint montant = address(this).balance; // On récupère tout l'argent du contrat   
        loyerPaye = false; // On remet à zéro pour le mois prochain 

        // Envoyer l'argent au propriétaire 
        payable(proprietaire).transfer(montant);
    }

    
}