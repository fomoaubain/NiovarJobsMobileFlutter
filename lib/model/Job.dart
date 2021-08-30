import 'dart:convert';

import 'package:flutter/material.dart';

class Job
{
  int id;
  int  Ins_id;
  int Typ_id;
  int Cat_id;
  String titre ;
  var description ;
  var responsabilite;
  var exigence;
  var niveauOrale;
  var niveauEcrire;
  String dateEntre ;
  String ville ;
  String heureTravail ;
  String jourTravail ;
  String pays;
  String province;

  var remuneration;
  String margeExperience;
  String immediat;
  var remuneration_n;
  String salaireAnnuel;
  String vedette;
  String negociable;
  String created;
  var masquerEmplacement;
  var adressePostal;
  var codePostal;
  var equipeEmploi;
  var DateEntreValeur;
  var dateEntrePoste;

  var dateDebut;
  var dateFin;
  var dateFinOffre;
  var immediatLabel;


  Categorie categorie;
 Contrat contrat;
  Langue langue;
  NiveauScolarite niveauScolarite;
  Quartravail quartravail;
  StatutEmploi statutEmploi;
  TypeOffre typeOffre;

  List<Diplome> lisDiplome;
  List<AvantageSociauxJob> avantageSociauxJob;


  Job({
      required this.id,
    required this.Ins_id,
    required  this.Typ_id,
    required  this.Cat_id,
    required  this.titre,
    required   this.description,
    required   this.responsabilite,
    required   this.exigence,
    required   this.niveauOrale,
    required   this.niveauEcrire,
    required  this.dateEntre,
    required this.ville,
    required  this.heureTravail,
    required   this.jourTravail,
    required  this.pays,
    required  this.province,
    required  this.remuneration,
    required  this.margeExperience,
    required  this.immediat,
    required  this.remuneration_n,
    required  this.salaireAnnuel,
    required this.vedette,
    required this.negociable,
    required this.created,
    required   this.masquerEmplacement,
    required   this.adressePostal,
    required   this.codePostal,
    required   this.equipeEmploi,
    required   this.DateEntreValeur,
    required   this.dateEntrePoste,
    required   this.dateDebut,
    required   this.dateFin,
    required  this.dateFinOffre,
    required  this.categorie,
    required  this.contrat,
    required  this.langue,
    required  this.niveauScolarite,
    required  this.quartravail,
    required  this.statutEmploi,
    required this.typeOffre,
    required   this.lisDiplome,
    required   this.avantageSociauxJob,
    required   this.immediatLabel
});

  factory Job.fromJson(Map<String, dynamic> json) {
    var tagObjsJson = json['Diplomes'] as List;
    List<Diplome> _tagsDiplomes = tagObjsJson.map((tagJson) => Diplome.fromJson(tagJson)).toList();

    var tagObjsJson2 = json['avantageSociauxJob'] as List;
    List<AvantageSociauxJob> _tagsAvantaSaciauxJob = tagObjsJson2.map((tagJson) => AvantageSociauxJob.fromJson(tagJson)).toList();
    return Job(
      id: json['id'],
      Ins_id: json['Ins_id'],
      Typ_id: json['Ins_id'],
      Cat_id: json['Cat_id'],
      titre: json['titre'] ,
      description: json['description'] ?? "Aucune donnee disponible",
      dateEntre: json['dateEntre'].toString(),
      remuneration:json['remuneration'].toString(),
      ville: json['ville'] ,
      pays: json['pays'] ,
      heureTravail: json['heureTravail'],
      jourTravail: json['jourTravail'],
      margeExperience: json['margeExperience'],
      immediat:  json['immediat'].toString(),
      remuneration_n: json['remuneration_n'].toString(),
      salaireAnnuel: json['salaireAnnuel'].toString(),
      vedette: json['vedette'].toString(),
      created: json['created'].toString(),
      negociable: json['negociable'].toString(),


      categorie: Categorie.fromJson(json['category']) ,
      contrat: Contrat.fromJson(json['contrat']) ,
      langue: Langue.fromJson(json['langue']) ,
      niveauScolarite: NiveauScolarite.fromJson(json['niveauScolarite']) ,
      quartravail: Quartravail.fromJson(json['quartTravail1']) ,
      statutEmploi: StatutEmploi.fromJson(json['statutEmploi']) ,
      typeOffre: TypeOffre.fromJson(json['TypeOffre']) ,
      lisDiplome: _tagsDiplomes,
      avantageSociauxJob: _tagsAvantaSaciauxJob,
      province: json['province'].toString(),
      codePostal: json['codePostal'].toString(),
      equipeEmploi: json['equipeEmploi'].toString(),

      dateFinOffre: json['dateFinOffre'],
      exigence: json['exigence'],
      DateEntreValeur: json['DateEntreValeur'],
      responsabilite: json['responsabilite'],
      niveauOrale: json['niveauOrale'],
      adressePostal: json['adressePostal'],
      dateEntrePoste: json['dateEntrePoste'],
      masquerEmplacement: json['masquerEmplacement'],
      dateDebut: json['dateDebut'],
      dateFin: json['dateFin'],
      niveauEcrire: json['niveauEcrire'],
      immediatLabel: json['immediatLabel'],


    );
  }

}


class Categorie {
  int id;
  int Typ_id;
  String libelle;
  String name;
  String image;

  Categorie({required this.id,required this.Typ_id,required this.libelle, required this.name, required this.image});

  factory Categorie.fromJson(Map<String, dynamic> json) {
    return Categorie(
      id: json['id'],
      Typ_id: json['Typ_id'],
      libelle: json['libelle'],
      name: json['name'],
      image: json['image'] ,

    );
  }
}

class Contrat {
  int id;
  String libelle;
  String name;

  Contrat({ required this.id, required this.libelle, required this.name });

  factory Contrat.fromJson(Map<String, dynamic> json) {
    return Contrat(
      id: json['id'],
      libelle: json['libelle'],
      name: json['name'],

    );
  }
}

class Langue {

  int id;
  String libelle;
  String name;

  Langue({ required this.id, required this.libelle, required this.name });

  factory Langue.fromJson(Map<String, dynamic> json) {
    return Langue(
      id: json['id'],
      libelle: json['libelle'],
      name: json['name'],

    );
  }
}

class NiveauScolarite {
  int id;
  String libelle;
  String name;

  NiveauScolarite({ required this.id, required this.libelle, required this.name });

  factory NiveauScolarite.fromJson(Map<String, dynamic> json) {
    return NiveauScolarite(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],

    );
  }
}

class Quartravail {
  int id;
  String libelle;
  String name;
  String description;

  Quartravail({ required this.id, required this.libelle, required this.name, required this.description});

  factory Quartravail.fromJson(Map<String, dynamic> json) {
    return Quartravail(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],
      description: json['description'],

    );
  }
}

class StatutEmploi {
  int id;
  String libelle;
  String name;

  StatutEmploi({ required this.id, required this.libelle, required this.name });

  factory StatutEmploi.fromJson(Map<String, dynamic> json) {
    return StatutEmploi(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],

    );
  }

}


class TypeOffre {
  int id;
  String libelle;
  String name;

  TypeOffre({ required this.id, required this.libelle, required this.name });

  factory TypeOffre.fromJson(Map<String, dynamic> json) {
    return TypeOffre(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],

    );
  }
}


class Diplome {
  int id;
  String libelle;
  String name;

  Diplome({ required this.id, required this.libelle, required this.name });

  factory Diplome.fromJson(Map<String, dynamic> json) {
    return Diplome(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],

    );
  }
}


class NiveauLangue {
  int id;
  String libelle;
  String name;

  NiveauLangue({ required this.id, required this.libelle, required this.name });

  factory NiveauLangue.fromJson(Map<String, dynamic> json) {
    return NiveauLangue(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],

    );
  }
}

class AvantageSociaux {
  int id;
  String libelle;
  String name;
  String description;
  String image;

  AvantageSociaux({
    required this.id,
    required this.libelle,
    required this.name,
    required this.description,
    required this.image

  });

  factory AvantageSociaux.fromJson(Map<String, dynamic> json) {
    return AvantageSociaux(
      id: json['id'],
      libelle: json['libelle'],
      name: json['libelle'],
      description: json['description'],
      image: json['image'],

    );
  }
}

class AvantageSociauxJob {
  int id;
  AvantageSociaux avantageSociaux;

  AvantageSociauxJob({
    required this.id,
    required this.avantageSociaux

  });

  factory AvantageSociauxJob.fromJson(Map<String, dynamic> json) {
    return AvantageSociauxJob(
      id: json['id'],

      avantageSociaux: AvantageSociaux.fromJson(json['avantageSociaux']),

    );
  }
}

class AssocLangueNiveau {

  int id;
  String libelle;
  Langue langue;
  NiveauLangue niveauLangue;


  AssocLangueNiveau({
    required this.id,
    required this.libelle,
    required this.langue,
    required this.niveauLangue,

  });

  factory AssocLangueNiveau.fromJson(Map<String, dynamic> json) {
    return AssocLangueNiveau(
      id: json['id'],
      libelle: json['libelle'],
      langue: Langue.fromJson(json['langue']) ,
      niveauLangue: NiveauLangue.fromJson(json['niveauLangue']),

    );
  }
}
