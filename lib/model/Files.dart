class Files
{
  int id;
  var Ins_id;
  var type ;
  var libelle ;
  var name ;
  var chemin ;
  var status ;
  var etat ;
  var created ;
  var fileName ;

  Files({
    required this.id,
    this.Ins_id,
    this.type,
    this.libelle,
    this.name,
    this.status,
    this.etat,
    this.created,
    this.chemin,
    this.fileName,

  });

  factory Files.fromJson(Map<String, dynamic> json) {
    return Files(
      id: json['id'],
      Ins_id: json['Ins_id'],
      type: json['type'],
      libelle: json['libelle'],
      name: json['name'],
      status: json['status'],
      etat: json['etat'],
      created: json['created'],
      chemin: json['chemin'],
      fileName: json['fileName'],
    );
  }

}