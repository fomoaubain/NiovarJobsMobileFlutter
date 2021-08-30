import 'dart:convert';

import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Job.dart';
class Postuler
{
  int id;

    String nbreAccept;
     String nbreApply ;
   String typeJob;
   int  Ins_id;
   int Job_id;

   String libelle;
   String datePostule ;
   String heurePostule ;
   String remuneration ;
   String etatAdmin ;
   String etat ;

   String status ;
    String created ;
   String etatClient ;
 String etatCandidat ;
 String approbation ;
 String signatures;

 String dateEntrevue;
 String heure;
 String responsableEntrevue;
 String duree;
 String outils;
   String signatureClient;
   String dateSignClient;


 String typeEntrevue;

   String image;
   String imageName;
    String companyId;
  Inscrire inscrire;
  Job job;


  Postuler({
    required  this.id,
      required this.nbreAccept,
    required   this.nbreApply,
    required this.typeJob,
    required  this.Ins_id,
    required  this.Job_id,

    required  this.libelle,
    required this.datePostule,
    required this.heurePostule,
    required  this.remuneration,
    required  this.etatAdmin,
    required  this.etat,

    required this.status,
    required this.created,
    required this.etatClient,
    required  this.etatCandidat,
    required  this.approbation,
    required this.signatures,

    required this.dateEntrevue,
    required  this.heure,
    required  this.responsableEntrevue,
    required  this.duree,
    required this.outils,
    required this.signatureClient,
    required this.dateSignClient,
    required  this.typeEntrevue,

    required this.image,
    required this.imageName,
    required this.companyId,
    required this.inscrire,
    required this.job,

});

   factory Postuler.fromJson(Map<String, dynamic> json) {
     return Postuler(
       id: json['id'],
       typeJob: json['typeJob'].toString(),
       Ins_id: json['Ins_id'],
       Job_id: json['Job_id'],
       libelle: json['libelle'],
       datePostule: json['datePostule'].toString(),
       heurePostule: json['heurePostule'].toString(),
       remuneration: json['remuneration'].toString(),
       etatAdmin: json['etatAdmin'].toString(),
       etat: json['etat'].toString(),
       status: json['status'].toString(),
       nbreApply: json['nbreApply'].toString(),
       nbreAccept: json['nbreAccept'].toString(),
       created: json['created'].toString(),
       etatClient: json['etatClient'].toString(),
       etatCandidat: json['etatCandidat'].toString(),
       approbation: json['approbation'].toString(),
       signatures: json['signatures'].toString(),
       dateEntrevue: json['dateEntrevue'].toString(),
       heure: json['heure'].toString(),
       typeEntrevue: json['typeEntrevue'].toString(),
       responsableEntrevue: json['responsableEntrevue'].toString(),
       duree: json['duree'].toString(),
       outils: json['outils'].toString(),
       signatureClient: json['signatureClient'].toString(),
       dateSignClient: json['dateSignClient'].toString(),
       image: json['image'].toString(),
       companyId: json['companyId'].toString(),
       imageName: json['imageName'].toString(),

      inscrire: Inscrire.fromJson(json['inscrire']) ,
       job: Job.fromJson(json['job']) ,




     );
   }

}