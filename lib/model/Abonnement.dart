import 'dart:convert';

class Abonnement
{
  int id;
  int Typ_id;
  String type;
  String titre ;
  String description ;
  String montant ;
  String amount ;
  String status ;
  String nbrePost ;
  String illimite ;
  String categorie;
  String promoPrice;
  String periode;
  String previewPrix;
  String free;

  List<SousAbonnement>  sousAbonnement;


  Abonnement({
  required  this.id,
    required this.Typ_id,
    required this.type,
    required  this.titre,
    required this.description,
    required  this.montant,
    required this.amount,
    required this.status,
    required this.nbrePost,
    required this.illimite,
    required this.categorie,
    required this.promoPrice,
    required  this.periode,
    required  this.previewPrix,
    required  this.free,

    required this.sousAbonnement
  }
      );

  factory Abonnement.fromJson(Map<String, dynamic> json) {

    var tagObjsJson = json['SousAbonnement'] as List;
    List<SousAbonnement> _tags = tagObjsJson.map((tagJson) => SousAbonnement.fromJson(tagJson)).toList();

    return Abonnement(
      id: json['id'],
      Typ_id: json['Typ_id'],
      type: json['type'],
      titre: json['titre'],
      description: json['description'],
      montant: json['montant'].toString(),
      amount: json['amount'].toString(),
      status:json['status'].toString() ,
      nbrePost: json['nbrePost'].toString(),
      illimite: json['illimite'].toString(),
      categorie: json['categorie'],
      promoPrice: json['promoPrice'].toString(),
      periode: json['periode'].toString(),
      previewPrix: json['previewPrix'].toString(),
      free: json['free'].toString(),


    sousAbonnement: _tags,

    );
  }

}



class SousAbonnement {
  int id;
  int Typ_id;
  int Abo_id;
  String titre;
  String description;
  String status;
  String nbrePost;
  String illimite;
  String created;

  SousAbonnement(
  {
  required  this.id,
  required this.Typ_id,
  required  this.Abo_id,
  required this.titre,
  required this.description,
  required this.status,
  required this.nbrePost,
  required this.illimite,
  required this.created
  });

  factory SousAbonnement.fromJson(Map<String, dynamic> json) {
    return SousAbonnement(
      id: json['id'],
      Typ_id: json['Typ_id'],
      Abo_id: json['Abo_id'],
      titre: json['titre'],
      description: json['description'],
      status: json['status'].toString(),
      nbrePost: json['nbrePost'].toString(),
      illimite:json['illimite'].toString() ,
      created: json['created'].toString(),
    );
  }


}