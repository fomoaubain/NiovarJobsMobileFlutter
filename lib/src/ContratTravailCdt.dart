import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Affectations.dart';
import 'package:niovarjobs/model/ContratTravail.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class ContratTravailCdt extends StatefulWidget {
  ContratTravail contratTravail;

  ContratTravailCdt(this.contratTravail);
  @override
    _ContratTravailCdt createState() => _ContratTravailCdt();
}

class _ContratTravailCdt extends State<ContratTravailCdt> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late FToast fToast;

  String prefix="Il/Elle", sufix="(e)", periode="";
  bool value = false;
  late final TextEditingController nom  = TextEditingController();
  late final TextEditingController tel  = TextEditingController();
  late final TextEditingController email  = TextEditingController();

  @override
  void initState() {
    if(widget.contratTravail.inscrire.sexe.toString().isNotEmpty && widget.contratTravail.inscrire.sexe.toString()=="F"){
      prefix="Elle";
      sufix="e";
    }else if(widget.contratTravail.inscrire.sexe.toString().isNotEmpty && widget.contratTravail.inscrire.sexe.toString()=="M"){
      prefix="Il";
      sufix="";
    }
    if(widget.contratTravail.periode.toString().isNotEmpty){
      widget.contratTravail.periode.toString()=="H" ? periode="Heure" : periode="Année";
    }
     nom.text=widget.contratTravail.nom;
    tel.text=widget.contratTravail.telTemoin;
    email.text=widget.contratTravail.courrielTemoin;

    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  Future ConfirmContratTravail(String idContrat, String nom, String tel, String courriel ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/confirmContratTravailCdt";
    var response = await dio.get(pathUrl,
        queryParameters: {
          'idContrat': idContrat,
          'nom': nom,
          'tel': tel,
          'courriel': courriel
        }
    );
    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constante.kSilver,
      appBar: AppBar(
        backgroundColor: Constante.kSilver,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constante.kBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Mon contrat de travail",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Center(
                child:Image.asset('assets/logo.png', height: 50.0),
              ),
            ),

            SizedBox(height: 10,),
            Center(
              child: Text("Direction générale ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
            Center(
              child: Text("Contrat ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
            SizedBox(height: 20,),
            Text("Le présent contrat est conclu pour une durée indéterminée entre  :",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
            SizedBox(height: 10,),
            Text("NiovarJobs (une filiale de Niovar Technologies Inc.),"),
            Text("Ayant son siège social au 3075 Boulevard Wilfrid Hamel suite 241"),
            Text("Adresse : 3075 Boulevard Wilfrid Hamel suite 241"),
            Text("Téléphone : 1-855-222-0975"),
            Text("Courriel : services@niovar.com"),

            SizedBox(height: 10,),
            Text("Et ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),
            SizedBox(height: 10,),
            Text("Nom complet de l’employé "+sufix+" : "+ widget.contratTravail.inscrire.nom.toString()),
            Text("Adresse : "+ widget.contratTravail.inscrire.adresse.toString()),
            Text("Téléphone : "+ widget.contratTravail.inscrire.phone.toString()),

            SizedBox(height: 10,),
            Text("Personne à contacter en cas d’urgence : ",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),),

            Form(
              key: formKey,
                child: Column(
              children: [
                SizedBox(height: 10,),
                TextFormField(
                  controller: nom,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Nom complet ",
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                  ),
                  validator: (String ? value){
                    if(value!.isEmpty){
                      return "Ce champ est obligatoire";
                    }
                    if(value.length>50){
                      return "maximum 50 caracteres";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  controller: tel,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Numéro de téléphone",
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                  ),
                  validator: (String ? value){
                    if(value!.isEmpty){
                      return "Ce champ est obligatoire";
                    }
                    if(value.length>50){
                      return "maximum 50 caracteres";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 5,),
                TextFormField(
                  controller: email,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Adresse courriel ",
                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black26)
                    ),
                  ),
                  validator: (String ? value){
                    if(value!.isEmpty){
                      return "Ce champ est obligatoire";
                    }
                    if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                      return "Adresse courriel incorrect";
                    }
                    if(value.length>50){
                      return "maximum 50 caracteres";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 10,),
              ],
            )),

            Center(
              child: Text("Le contexte ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),

            SizedBox(height: 10,),
            Text("NiovarJobs, par le biais de son représentant, estime que " +widget.contratTravail.inscrire.nom.toString()+ " demeurant au : "+ widget.contratTravail.inscrire.adresse.toString()+ ", "
            "possède les compétences et atouts nécessaires pour être engagé"+sufix +" en qualité  de  "+ widget.contratTravail.titreEmploi.toString()),
            SizedBox(height: 10,),
            Center(
              child: Text(" Il a été convenu se qui suit  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(" 1. Durée du contrat et date d'entrée en vigueur :  ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("L’employé"+sufix +" se déclarant libre de tous engagements professionnels est embauché"+sufix +"  à partir du :"+ widget.contratTravail.dateEmbauche.toString()+ " pour un contrat de durée indéterminée."),
            SizedBox(height: 10,),

            Center(
              child: Text("2. Description du travail ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("  L’employé"+ sufix +" est engagé$sufix en qualité de :"+ widget.contratTravail.titreEmploi.toString() +
    "selon les termes et conditions énoncées dans ce contrat. "+prefix +" accepte d’être subordonné"+sufix +" à l’autorité, la gestion, la direction et au conseil de l’entreprise NiovarJobs."+
    prefix+ " effectuera toutes les tâches qui lui seront confiées par son supérieur immédiat, tant qu’elles seront raisonnables et normalement effectuées par des personnes engagées dans des postes semblables."+
    "NiovarJobs., se réserve le droit de modifier le poste ou des attributions ou des responsabilités de l’employé" +sufix+ " tant que la modification est raisonnable et faite conformément aux droits et normes du travail."+
    "L’employé"+sufix+ " accepte de respecter les règles, normes, politiques et pratiques de l’entreprise NiovarJobs (Niovar Technologies Inc.), y compris ses modifications successives."),
            SizedBox(height: 10,),

            Center(
              child: Text("3. Rémuneration ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text(" NiovarJobs, convient de payer à l’employé"+sufix+" en contrepartie de son travail, une rémunération brute de "+ widget.contratTravail.salaireNegocier.toString() +" \$ / "+ periode +" de travail." +
             " La période de paie commence le dimanche et se termine le samedi, la rémunération est versée aux deux semaines par dépôt direct."),
            SizedBox(height: 10,),
            Center(
              child: Text("4. Horaire de travail ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("L’employé"+sufix +" travaillera sur un horaire variable. Son horaire peut être sujet à changement sans préavis. "+prefix+" aura droit à une période de repas de :  1h sans salaire par quart de travail.  Notre entreprise est ouverte 24h/24 et 365 jours / an."+
    "Toute absence planifiée, pour un quart de travail doit être notifiée avec un délai de 5 jour ouvrable. Toute absence non planifiée doit être justifiée par des preuves convaincantes tel qu’un papier médical ou tous autres documents pertinents pour ne pas entraîner une note négative au dossier de l’employé"+sufix+"."),
            SizedBox(height: 10,),



            Center(
              child: Text("5. Période de probation ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("Une période de probation de 3 mois est prévue afin que l’employé $sufix soit maintenu $sufix dans ce poste."),
            Text("Les formations suivantes sont exigées à la réalisation adéquate des tâches de ce poste :"),
            Html(
              data: widget.contratTravail.formation.toString(),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text("6. Vacances et congés ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("L’employé$sufix aura droit à des congés annuels. La date du congé sera fixée par l’employeur après consultation de la direction des ressources humaines. Les congés non pris donneront droit à un versement d’une indemnité compensatrice de congés payés."),
            SizedBox(height: 10,),
            Center(
              child: Text("7. Clause partilière de non-concurrence", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text(" L’employé$sufix ne pourra travailler chez nos clients : particuliers, tous organismes publics ou privés pour le compte d’une autre agence pendant toute la durée du contrat et pour une période de 6 mois après la fin de celui-ci."),
            SizedBox(height: 10,),
            Center(
              child: Text("8. Avis de démission", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("Si l’employé$sufix désire mettre fin au présent contrat, il convient de donner à l’employeur un délai raisonnable de deux semaines équivalant à ce dernier lui aurait donner en vertu de la loi."),
            SizedBox(height: 10,),
            Center(
              child: Text("9. Avis de cessation d'emploi", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 10,),
            Text("En cas de mise à pied, ou de cessation d’emploi de plus de 6 mois, l’employeur enverra un avis écrit à l’employé$sufix à cet effet."),
            SizedBox(height: 10,),

            Text(" EN FOI DE QUOI,", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            Text(" les parties attestent qu’elles ont lu et accepté les conditions et modalités énoncées dans le présent contrat.", ),
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: Row(
                children:[
                  Container(
                    height: 20,width: 20,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1,
                      ),
                      borderRadius: new BorderRadius.circular(5),
                    ),
                    child: Theme(
                      data: ThemeData(
                        unselectedWidgetColor: Colors.transparent,
                      ),
                      child: Checkbox(
                        value: this.value,
                        // shape: CircleBorder(),
                        onChanged: (value) {
                          setState(() {
                            this.value = value!;
                            setState(() {
                              // value ? showDateFinTextFields=false : showDateFinTextFields=true;
                            });
                          });
                        },
                        activeColor: Colors.transparent,
                        checkColor: Constante.primaryColor,
                        materialTapTargetSize: MaterialTapTargetSize.padded,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 13,
                  ),
                  Text(
                    "J'ai lu et j'accepte les termes du contrat",
                    style: Constante.style4,
                  ), //Text
                ], //<Widget>[]
              ),
            ),
            Text("NiovarJobs (Niovar Technologies Inc.)."),
            SizedBox(height: 10,),
            ShowDateSign()
          ],
        ),
      ),
      floatingActionButton: widget.contratTravail.etatSignClient.toString()=="2" && widget.contratTravail.etatSignCdt.toString()=="1" ? FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          if(value){
            if(formKey.currentState!.validate()){
              Constante.showAlert(context, "Veuillez patientez", "Confirmation en cour...", SizedBox(), 100);
              await ConfirmContratTravail(widget.contratTravail.id.toString(),nom.text,tel.text, email.text ).then((value) async {
                if(value['result_code'].toString().contains("1")){
                  Navigator.pop(context);
                  Navigator.pop(context,true);
                }else{
                  Navigator.pop(context);
                  Constante.showAlert(context, "Note d'information", value['message'].toString(),
                      SizedBox(
                        child: RaisedButton(
                          padding: EdgeInsets.all(10),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Fermer",
                            style: TextStyle(color: Colors.white),
                          ),
                          color:Colors.orange,
                        ),
                      ),
                      170);
                }

              }
              );
            }else{
              Constante.showToastError("Veuillez renseignez les informations du témoin.",fToast);
            }

          }else{
            Constante.showToastError("Veuillez cocher la case",fToast);
          }
          if(formKey.currentState!.validate()){

          }
        },
        child: Icon(Icons.check),
      ) : SizedBox(),
    );
  }

  Widget ShowDateSign() {
    if(widget.contratTravail.etatSignClient.toString()=="2" && widget.contratTravail.etatSignCdt.toString()=="1"){
      return  Column(
        children: [
          setStatus("En attente de votre signature(confirmation) ", Colors.orange),
        ],
      );
    }else if(widget.contratTravail.etatSignClient.toString()=="2" && widget.contratTravail.etatSignCdt.toString()=="2"){
      return  Column(
        children: [
          setStatus("Contrat lu et approuvée par le l'employé$sufix "+widget.contratTravail.inscrire.nom.toString(), Colors.green),
          SizedBox(height: 10,),
          Text("Date signature : "+ widget.contratTravail.dateSign.toString()),
        ],
      );
    }
    return  SizedBox();
  }

  Widget setStatus( String msg, Color colors){
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10.0),
          padding:
          EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: colors,
          ),
          child: Text(
            msg,
            style: Constante.kSubtitleStyle.copyWith(
              color: Colors.white,
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );
  }
}