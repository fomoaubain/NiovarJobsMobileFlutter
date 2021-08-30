import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Affectations.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class ContratAffectationCdt extends StatefulWidget {
  Affections affections;

  ContratAffectationCdt(this.affections);
  @override
  _ContratAffectationCdt createState() => _ContratAffectationCdt();
}

class _ContratAffectationCdt extends State<ContratAffectationCdt> {

  String sufix="(e)", genre= "Monsieur/Madame", periode="";
  bool value = false;
  late FToast fToast;

  Future ConfirmContratAffectation(String idContrat) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/ConfirmContratAffectationCdt";
    var response = await dio.get(pathUrl,
        queryParameters: {'idContrat': idContrat}
    );
    return response.data;
  }

  @override
  void initState() {
    if(widget.affections.inscrire.sexe.isNotEmpty && widget.affections.inscrire.sexe.toString()=="F"){
      genre="Madame";
      sufix="e";
    }else if(widget.affections.inscrire.sexe.isNotEmpty && widget.affections.inscrire.sexe.toString()=="M"){
      genre="Monsieur";
      sufix="";
    }

    if(widget.affections.periode.toString().isNotEmpty){
      widget.affections.periode.toString()=="H" ? periode="Heure" : periode="Année";
    }
    super.initState();
    fToast = FToast();
    fToast.init(context);
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
          "Mon contrat d'affection",
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
            Text("Adresse de NiovarJobs :"),
            Text("Tél sans frais : 1 855-222-0975"),
            Text("Courriel : services@niovarjobs.com"),
            Text("Site web : niovarjobs.com"),

            Container(
              alignment: Alignment.topRight,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Nom de l’employé"+sufix + " : "+ widget.affections.inscrire.nom.toString()),
                  Text("Adresse complete : " + widget.affections.inscrire.adresse.toString()),
                  Text("Tél de l’employé"+sufix + " : "+widget.affections.inscrire.phone.toString()),
                  Text("Courriel de l’employé"+sufix + " : "+widget.affections.inscrire.email.toString()),


                ],
              ),
            ),
            SizedBox(height: 20,),
            Container(
              alignment: Alignment.topRight,
              child:  Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text("Québec le : "+ widget.affections.created, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),),
                ],
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text("Objet : Lettre d’affectation - " + widget.affections.objet.toString(), style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text("Contrat d'affectation ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
            ),
            SizedBox(height: 20,),
            Text(genre+";"),
            Text(" Le présent document est pour confirmer votre affectation en tant que : "+ widget.affections.titreEmploi.toString()+" à  "+widget.affections.adresseEmploi+" pour le compte : "+widget.affections.libelleCompte+" via votre employeur NiovarJobs (Niovar Technologies Inc.)"),
            Text(" Votre affectation débute officiellement le : "+ widget.affections.dateDebut),
            Text(" Votre salaire sera de : "+ widget.affections.inscrire.salaireNegocier.toString() +" \$ "+periode),
            SizedBox(height: 10,),
            Center(
              child: Text("Salaire ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            ),
            Text(" Dans le cadre de votre affectation, vous serez a amené à faire les tâches suivantes (Noter que la liste des tâches n’est pas exhaustive) : "),
            Html(
              data: widget.affections.taches.toString(),
            ),
            Text(" Nous vous recommandons fortement d’avoir une copie papier ou électronique du présent document sur vous en tout temps."),
            SizedBox(height: 20,),
            Text("Meilleures salutations."),
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
                               this.value = value;
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
      floatingActionButton: widget.affections.etatSignClient.toString()=="2" && widget.affections.etatSignCdt.toString()=="1" ? FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          if(value){
            Constante.showAlert(context, "Veuillez patientez", "Confirmation en cour...", SizedBox(), 100);
            await ConfirmContratAffectation(widget.affections.id.toString()).then((value) async {
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
            Constante.showToastError("Veuillez cocher la case",fToast);
          }
        },
        child: Icon(Icons.check),
      ) : SizedBox(),
    );
  }

  Widget ShowDateSign() {
    if(widget.affections.etatSignClient.toString()=="2" && widget.affections.etatSignCdt.toString()=="1"){
      return  Column(
        children: [
          setStatus("En attente de votre signature(confirmation) ", Colors.orange),
        ],
      );
    }else if(widget.affections.etatSignClient.toString()=="2" && widget.affections.etatSignCdt.toString()=="2"){
      return  Column(
        children: [
          setStatus("Contrat lu et approuvée par le candidat "+widget.affections.inscrire.nom.toString(), Colors.green),
          SizedBox(height: 10,),
          Text("Date signature : "+ widget.affections.dateSign),
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