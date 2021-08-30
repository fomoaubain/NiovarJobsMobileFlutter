class Experience
{
  int id;
  var libelle;
  var name ;
  var status ;


  Experience({
    required this.id, this.libelle, this.name,  this.status});

  factory Experience.fromJson(Map<String, dynamic> json) {

    return Experience(
      id: json['id'],
      libelle: json['libelle'],
      name: json['name'],
      status: json['status'].toString(),

    );
  }

}