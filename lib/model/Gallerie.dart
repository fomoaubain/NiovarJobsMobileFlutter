class Gallerie
{
  int id;
  var libelle;
  var Pag_id;
  var image;

  Gallerie({
    required this.id,
    this.libelle,
    this.Pag_id,
    this.image,

  });

  factory Gallerie.fromJson(Map<String, dynamic> json) {
    return Gallerie(
      id: json['id'],
      libelle: json['libelle'],
      Pag_id: json['Pag_id'],
      image: json['image'],
    );
  }

}