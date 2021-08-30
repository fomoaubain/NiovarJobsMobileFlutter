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