import 'package:niovarjobs/model/Inscrire.dart';

class Location
{
  int id;
  var Ins_id;
  var Ins_id2 ;
  var dateDebut ;
  var dateFin ;
  var periode ;
  var type ;
  var journeeLocation ;
  var pays ;
  var province ;
  var ville ;
  var adresseLocation ;
  var heureTravail ;
  var description ;
  var montant ;
  var signClient ;
  var signCandidat ;
  var remuneration ;
  var remunerationCdt ;
  var dateSgnClt ;
  var dateSgnCdt ;
  var avisClient ;
  var avisCandidat ;
  var status ;
  var etat ;
  var created ;
  Inscrire candidat ;
  Inscrire company ;


  Location({
      required this.id,
      this.Ins_id,
      this.Ins_id2,
      this.dateDebut,
      this.dateFin,
      this.periode,
      this.type,
      this.journeeLocation,
      this.pays,
      this.province,
      this.ville,
      this.adresseLocation,
      this.heureTravail,
      this.description,
      this.montant,
      this.signClient,
      this.signCandidat,
      this.remuneration,
      this.remunerationCdt,
      this.dateSgnClt,
      this.dateSgnCdt,
      this.avisClient,
      this.avisCandidat,
      this.status,
      this.etat,
      this.created,
      required this.candidat,
      required this.company
  });

  factory Location.fromJson(Map<String, dynamic> json) {

    return Location(
      id: json['id'],
      Ins_id: json['Ins_id'],
      Ins_id2: json['Ins_id2'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      periode: json['periode'],
      type: json['type'],
      journeeLocation: json['journeeLocation'],
      pays: json['pays'],
      province: json['province'],
      ville: json['ville'],
      adresseLocation: json['adresseLocation'],
      heureTravail: json['heureTravail'],
      description: json['description'],
      montant: json['montant'],
      signClient: json['signClient'],
      signCandidat: json['signCandidat'],
      remuneration: json['remuneration'],
      remunerationCdt: json['remunerationCdt'],
      dateSgnClt: json['dateSgnClt'],
      dateSgnCdt: json['dateSgnCdt'],
      avisClient: json['avisClient'],
      avisCandidat: json['avisCandidat'],
      status: json['status'],
      etat: json['etat'],
      created: json['created'],
      candidat: Inscrire.fromJson(json['candidat']),
      company: Inscrire.fromJson(json['company'])

    );
  }

}