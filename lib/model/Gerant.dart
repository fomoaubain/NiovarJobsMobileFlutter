class Gerant
{
  int id;
  var nom;
  var prenom;
  var email;
  var roles;
  var etat;
  var statut;
  var roleGerantRH;
  var roleGerantAC;
  var created;


  Gerant({
    required this.id,
    this.nom,
    this.prenom,
    this.email,
    this.roles,
    this.etat,
    this.statut,
    this.roleGerantRH,
    this.roleGerantAC,
    this.created,

  });

  factory Gerant.fromJson(Map<String, dynamic> json) {
    return Gerant(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      roles: json['roles'],
      etat: json['etat'],
      statut: json['statut'],
      roleGerantRH: json['roleGerantRH'],
      roleGerantAC: json['roleGerantAC'],
      created: json['created']

    );
  }

}