import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Postuler.dart';

import 'Inscrire.dart';
import 'Postuler.dart';

class ContratTravail
{
  int id;
  var titreEmploi;
  var salaireNegocier;
  var description ;
  var autre ;
  var etatSignCdt ;
  var etatSignClient ;
  var dateSign ;
  var etat ;
  var telTemoin ;
  var courrielTemoin ;
  var formation ;
  var nom ;
  var periode ;
  var idPostuler ;
  var dateEmbauche ;
  //Postuler postuler ;
  Inscrire inscrire ;
  var created ;

  ContratTravail({
    required this.id,
    this.titreEmploi,
    this.salaireNegocier,
    this.description,
    this.autre,
    this.etatSignCdt,
    this.etatSignClient,
    this.dateSign,
    this.etat,
    this.telTemoin,
    this.courrielTemoin,
    this.formation,
    this.nom,
    this.periode,
    this.idPostuler,
    this.dateEmbauche,
    //required this.postuler,
    required this.inscrire,
    this.created,
  });

  factory ContratTravail.fromJson(Map<String, dynamic> json) {

    return ContratTravail(
      id: json['id'],
      titreEmploi: json['titreEmploi'],
      salaireNegocier: json['salaireNegocier'],
      description: json['description'],
      autre: json['autre'],
      etatSignCdt: json['etatSignCdt'],
      etatSignClient: json['etatSignClient'],
      dateSign: json['dateSign'],
      etat: json['etat'],
      telTemoin: json['telTemoin'],
      courrielTemoin: json['courrielTemoin'],
      formation: json['formation'],
      nom: json['nom'],
      periode: json['periode'],
      idPostuler: json['idPostuler'],
      dateEmbauche: json['dateEmbauche'],
      //postuler: json['Postuler'],

      inscrire: Inscrire.fromJson(json['Inscrire']),
      created: json['created'],
    );
  }

}