class Types
{
  int id;
  var libelle;
  var name ;
  var image ;
  var status ;


  Types({
    required this.id, this.libelle, this.name, this.image, this.status});

  factory Types.fromJson(Map<String, dynamic> json) {
    return Types(
      id: json['id'],
      libelle: json['libelle'],
      name: json['name'],
      image: json['image'],
      status: json['status'].toString(),

    );
  }

}

