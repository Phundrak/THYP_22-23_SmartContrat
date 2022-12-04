## Vocabulaires trouvés

Un seul vocabulaire trouvé put être importé, le [*Accomodation
Ontology*](https://lov.linkeddata.es/dataset/lov/vocabs/acco). Il
pourraît être utilisé dans le cadre où un ticket vendu se réfère à une
location de chambre d’hôtel, de place de camping, etc.

La classe principalement utilisée est `acco:HotelRoom` qui peut
ensuite se décomposer un plusieurs éléments se référent à des détails
de la réservation, comme le nombre de lits (`acco:quantity` via
`acco:bed`), le type de lits (`typeOfBed`), le prix
(`gr:QuentitativeValue` via `acco:occupancy`), l’hôtel dont la chambre
fait partie (`acco:partOf` pointe vers un `acco:Hotel`), etc…

## Vocabulaires intéressants, mais inaccessibles
Un autre vocabulaire semblait intéressant, le [*Event
Ontology*](https://lov.linkeddata.es/dataset/lov/vocabs/event). Hélas,
il semblerait que les ressources permettant d’importer ce vocabulaire
ne soient plus en ligne. Ce vocabulaire aurait pu permettre le détail
d’événements plus génériques que des réservations, en précisant par
exemple les dates de l’événement (`event:time`), le produit associé
(`event:product`), l’entité associée (`event:agent`), etc…

De même, le [*EPCIS Event
Model*](https://lov.linkeddata.es/dataset/lov/vocabs/eem) ne semble
pas disponible, le nom de domaine même de l’URI et du namespace du
vocabulaire ne semblant plus être joignable.
