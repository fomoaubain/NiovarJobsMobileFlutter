import 'dart:convert';

class Inscrire
{
  int id;
  String  type;
  String nom;
  String login;
  String email ;
  String password ;
  String phone ;
  String website ;
  String description ;
  String facebook ;
  String linkedin ;
  String pays;
  String ville;
  String adresse;
  String titreEmploi;
  String anneeExperience;
  String salaireSouhaiter;
  String salaireNegocier;
String profil;


String emailProf;
String categorie;
String domaine;
String codePostal;
String nomRepresentant;
String prenomRepresentant;
String numeroPoste;
String province;


  String titreRepresentant;
String telRepresentant;
String fcmToken;

String employeStatus;
String sexe;
String profilCompagnie;

String profilName;
var libelleTitreEmploi;

var NbrePost;


  Inscrire({
     required this.id,
    required this.type,
    required this.nom,
    required this.login,
    required this.email,
    required this.password,
    required  this.phone,
    required this.website,
    required this.description,
    required this.facebook,
    required this.linkedin,
    required this.pays,
    required this.ville,
    required this.adresse,
    required this.titreEmploi,
    required  this.anneeExperience,
    required  this.salaireSouhaiter,
    required this.salaireNegocier,
    required this.profil,
    required this.emailProf,
    required this.categorie,
    required this.domaine,
    required this.codePostal,
    required this.nomRepresentant,
    required this.prenomRepresentant,
    required this.numeroPoste,
    required this.province,
    required this.titreRepresentant,
    required this.telRepresentant,
    required this.fcmToken,
    required this.employeStatus,
    required  this.sexe,
    required  this.profilCompagnie,
    required  this.profilName,
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
      phone:json['phone'].toString(),
      website: json['website'].toString(),
      facebook: json['facebook'].toString(),
      linkedin: json['linkedin'].toString(),
      pays: json['pays'].toString(),
      province: json['province'],
      ville: json['ville'],
      adresse: json['adresse'].toString(),
      titreEmploi: json['titreEmploi'],
      anneeExperience: json['anneeExperience'].toString(),
      salaireSouhaiter: json['salaireSouhaiter'].toString(),
      salaireNegocier: json['salaireNegocier'].toString(),

      nomRepresentant: json['nom_representant'],
      profil: json['profilName'],
      emailProf: json['email_prof'],
      telRepresentant: json['tel_representant'].toString(),
      codePostal: json['code_postal'].toString(),
      numeroPoste: json['numero_poste'].toString(),
      titreRepresentant: json['titre_representant'],
      prenomRepresentant: json['prenom_representant'],
      sexe: json['sexe'],
      domaine: json['domaine'].toString(),
      employeStatus: json['employeStatus'].toString(),
      fcmToken: json['salaireNegocier'].toString(),
      categorie: json['categorie'].toString(),
      profilCompagnie: json['profilCompagnie'].toString(),
      profilName: json['profilName'].toString(),
      NbrePost: json['NbrePost'].toString(),
      libelleTitreEmploi: json['libelleTitreEmploi'],




    );
  }

}