import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Postuler.dart';

import 'Inscrire.dart';
import 'Postuler.dart';

class Affections
{
  int id;
  var titreEmploi;
  var salaireNegocier;
  var tauxHoraire ;
  var remuneration ;
  var etatSignCdt ;
  var etatSignClient ;
  var dateSign ;
  var etat ;
  var objet ;
  var adresseEmploi ;
  var libelleCompte ;
  var dateDebut ;
  var taches ;
  var periode ;
  var idPostuler ;
 // Postuler postuler ;
  Inscrire inscrire ;
  var created ;


  Affections({
    required this.id,
    this.titreEmploi,
    this.salaireNegocier,
    this.tauxHoraire,
    this.remuneration,
    this.etatSignCdt,
    this.etatSignClient,
    this.dateSign,
    this.etat,
    this.objet,
    this.adresseEmploi,
    this.libelleCompte,
    this.dateDebut,
    this.taches,
    this.periode,
    this.idPostuler,
  //  required this.postuler,
    required this.inscrire,
    this.created,
  });

  factory Affections.fromJson(Map<String, dynamic> json) {

    return Affections(
      id: json['id'],
      titreEmploi: json['titreEmploi'],
      salaireNegocier: json['salaireNegocier'],
      tauxHoraire: json['tauxHoraire'],
      remuneration: json['remuneration'],
      etatSignCdt: json['etatSignCdt'],
      etatSignClient: json['etatSignClient'],
      dateSign: json['dateSign'],
      etat: json['etat'],
      objet: json['objet'],
      adresseEmploi: json['adresseEmploi'],
      libelleCompte: json['libelleCompte'],
      dateDebut: json['dateDebut'],
      taches: json['taches'],
      periode: json['periode'],
      idPostuler: json['idPostuler'],
     // postuler: json['Postuler'],
      inscrire: Inscrire.fromJson(json['Inscrire']),
      created: json['created'],

    );
  }

}