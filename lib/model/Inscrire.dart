import 'dart:convert';

class Inscrire
{
  int id;
  var  type;
  var nom;
  var login;
  var email ;
  var password ;
  var phone ;
  var website ;
  var description ;
  var facebook ;
  var linkedin ;
  var pays;
  var ville;
  var adresse;
  var titreEmploi;
  var anneeExperience;
  var salaireSouhaiter;
  var salaireNegocier;
  var profil;


  var emailProf;
  var categorie;
  var domaine;
  var codePostal;
  var nomRepresentant;
  var prenomRepresentant;
  var numeroPoste;
  var province;


  var titreRepresentant;
  var telRepresentant;
  var fcmToken;

  var employeStatus;
  var sexe;
  var profilCompagnie;

  var profilName;
var libelleTitreEmploi;

var NbrePost;


  Inscrire({
     required this.id,
     this.type,
     this.nom,
     this.login,
     this.email,
     this.password,
      this.phone,
     this.website,
     this.description,
     this.facebook,
     this.linkedin,
     this.pays,
     this.ville,
     this.adresse,
     this.titreEmploi,
      this.anneeExperience,
      this.salaireSouhaiter,
     this.salaireNegocier,
     this.profil,
     this.emailProf,
     this.categorie,
     this.domaine,
     this.codePostal,
     this.nomRepresentant,
     this.prenomRepresentant,
     this.numeroPoste,
     this.province,
     this.titreRepresentant,
     this.telRepresentant,
     this.fcmToken,
     this.employeStatus,
      this.sexe,
      this.profilCompagnie,
      this.profilName,
      this.NbrePost,
    this.libelleTitreEmploi

  });

  factory Inscrire.fromJson(Map<String, dynamic> json) {
    return Inscrire(
      id: json['id'],
      type: json['type'],
      nom: json['nom'],
      login: json['login'],
      email: json['email'],
      description: json['description'],
      password: json['password'],
      phone:json['phone'],
      website: json['website'],
      facebook: json['facebook'],
      linkedin: json['linkedin'],
      pays: json['pays'],
      province: json['province'],
      ville: json['ville'],
      adresse: json['adresse'],
      titreEmploi: json['titreEmploi'],
      anneeExperience: json['anneeExperience'] ,
      salaireSouhaiter: json['salaireSouhaiter'],
      salaireNegocier: json['salaireNegocier'],

      nomRepresentant: json['nom_representant'],
      profil: json['profilName'],
      emailProf: json['email_prof'],
      telRepresentant: json['tel_representant'],
      codePostal: json['code_postal'],
      numeroPoste: json['numero_poste'],
      titreRepresentant: json['titre_representant'],
      prenomRepresentant: json['prenom_representant'],
      sexe: json['sexe'],
      domaine: json['domaine'],
      employeStatus: json['employeStatus'],
      fcmToken: json['salaireNegocier'],
      categorie: json['categorie'],
      profilCompagnie: json['profilCompagnie'],
      profilName: json['profilName'],
      NbrePost: json['NbrePost'],
      libelleTitreEmploi: json['libelleTitreEmploi'],
    );
  }

}