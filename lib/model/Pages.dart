import 'package:niovarjobs/model/Inscrire.dart';

class Pages
{
  int id;
  var aPropos;
  var couleurFond ;
  var description ;
  var nomPage ;
  var pourquoiPostuler ;
  var profil ;
  var profilPage ;
  Inscrire company ;


  Pages({
    required this.id,
    this.aPropos,
    this.couleurFond,
    this.description,
    this.nomPage,
    this.pourquoiPostuler,
    this.profil,
    this.profilPage,
    required this.company,

  });

  factory Pages.fromJson(Map<String, dynamic> json) {
    return Pages(
      id: json['id'],
      aPropos: json['aPropos'],
      couleurFond: json['couleurFond'],
      description: json['description'],
      nomPage: json['nomPage'],
      pourquoiPostuler: json['pourquoiPostuler'],
      profil: json['profil'],
      profilPage: json['profilPage'],
      company: Inscrire.fromJson(json['company']),

    );
  }

}