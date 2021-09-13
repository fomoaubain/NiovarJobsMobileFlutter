class Avis
{
  int id;
  var libelle;
  var iduser;
  var Pag_id;
  var nbreEtoile;
  var Profil;
  var Pseudo;
  var created;


  Avis({
    required this.id,
    this.libelle,
    this.iduser,
    this.Pag_id,
    this.nbreEtoile,
    this.Profil,
    this.Pseudo,
    this.created,
  });

  factory Avis.fromJson(Map<String, dynamic> json) {
    return Avis(
      id: json['id'],
      libelle: json['libelle'],
      iduser: json['iduser'],
      Pag_id: json['Pag_id'],
      nbreEtoile: json['nbreEtoile'],
      Profil: json['Profil'],
      Pseudo: json['Pseudo'],
      created: json['created'],
    );
  }

}