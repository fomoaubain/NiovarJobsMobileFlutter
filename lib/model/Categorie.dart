import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Type.dart';

class Categorie
{
  int id;
  int Typ_id;
  var libelle;
  var name ;
  var image ;
  var status ;


  Categorie({
      required this.id, required this.Typ_id, this.libelle, this.name, this.image, this.status});

  factory Categorie.fromJson(Map<String, dynamic> json) {

    return Categorie(
      id: json['id'],
      Typ_id: json['Typ_id'],
      libelle: json['libelle'],
      name: json['name'],
      image: json['image'],
      status: json['status'].toString(),

    );
  }

}


class SouscrireCat
{
  int id;
  var Ins_id;
  var Typ_id;
  var etat;
  var archived ;
  var status ;
  var created ;
  var inscrire ;
  var types ;

  SouscrireCat({
    required this.id,
    this.Ins_id,
    this.Typ_id,
    this.etat,
    this.archived,
    this.status,
    this.created,
    this.inscrire,
    this.types
  });

  factory SouscrireCat.fromJson(Map<String, dynamic> json) {
    return SouscrireCat(
      id: json['id'],
      Ins_id: json['Ins_id'],
      Typ_id: json['Typ_id'],
      etat: json['etat'],
      archived: json['archived'],
      status: json['status'],
      created: json['created'],
      inscrire: Inscrire.fromJson(json['inscrire']),
      types: Types.fromJson(json['types']),
    );
  }

}