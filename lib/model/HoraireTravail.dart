class HoraireTravail
{
  int id;
  var libelle;
  var status ;


  HoraireTravail({
    required this.id, this.libelle, this.status});
  factory HoraireTravail.fromJson(Map<String, dynamic> json) {

    return HoraireTravail(
      id: json['id'],
      libelle: json['libelle'],
      status: json['status'].toString(),

    );
  }

}