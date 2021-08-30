import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:niovarjobs/model/Categorie.dart';
import 'package:niovarjobs/model/Experience.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Type.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart'  as session;
class Social_infos extends StatefulWidget {


  @override
  _Social_infos createState() => _Social_infos();
}

class _Social_infos extends State<Social_infos> {
  late FToast fToast;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late  final TextEditingController facebook;
  late final TextEditingController linkedin ;
  late Future <Inscrire> currentInscrire;

  late Inscrire inscrire;

  Future<Inscrire> fetchItem() async {

    final responseInscrire = await http.get(Uri.parse(Constante.serveurAdress+"RestUser/getUser/"+session.id));
    if (responseInscrire.statusCode == 200) {
      final data = jsonDecode(responseInscrire.body)['user'];
      if (data != null) {
        inscrire = Inscrire.fromJson(data);
        facebook = TextEditingController(text: inscrire.facebook);
        linkedin = TextEditingController(text: inscrire.linkedin);
      }
    }

    return inscrire;
  }


  Future EditInfos(var id, var facebook, var linkedin) async {

    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Edit";
    FormData formData = new FormData.fromMap({
      'id': id,
      'linkedin': linkedin,
      'facebook': facebook,

    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }


  @override
  void initState() {
    super.initState();
    currentInscrire= this.fetchItem() ;
    fToast = FToast();
    fToast.init(context);

  }

  @override
  Widget build(BuildContext context) {
    Size size=MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Constante.kSilver,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
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
          "Réseaux sociaux",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          ShowCheckButton()  ,

        ],
      ),

      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child: FutureBuilder<Inscrire>(
            future: currentInscrire,
            builder: (context, snapshot){
              if(snapshot.connectionState != ConnectionState.done) {
                return Constante.circularLoader();
              }
              if(snapshot.hasError) {
                return Center(
                    child: Text("Aucune connexion disponible", style: TextStyle(color:  Color(0xFFFA5805), fontSize: 16.0))
                );
              }

              if(snapshot.hasData) {
                return Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(height:size.height*0.02),
                        Text("Lien vers facebook", style: Constante.style4,),
                        SizedBox(height:size.height*0.01),
                        TextFormField(
                          obscureText: false,
                          controller: facebook,
                          decoration: InputDecoration(
                            hintText: "Saisir ici",
                            contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Constante.kBlack.withOpacity(0.2))
                            ),

                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26)
                            ),
                          ),
                          validator: (String ? value){
                            if(value!.isEmpty){
                              return "";
                            }
                            if(value.length>50){
                              return "maximum 50 caracteres";
                            }
                            return null;
                          },
                        ),
                        SizedBox(height:size.height*0.02),
                        Text("Lien vers linkedin", style: Constante.style4,),
                        SizedBox(height:size.height*0.01),
                        TextFormField(
                          obscureText: false,
                          controller: linkedin,
                          decoration: InputDecoration(
                            hintText: "Saisir ici",
                            contentPadding: EdgeInsets.symmetric(vertical: 17, horizontal: 15),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                                borderSide: BorderSide(color: Constante.kBlack.withOpacity(0.2))
                            ),
                            border: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black26)
                            ),
                          ),
                          validator: (String ? value){
                            if(value!.isEmpty){
                              return "";
                            }
                            if(value.length>50){
                              return "maximum 50 caracteres";
                            }
                            return null;
                          },

                        ),


                      ],
                    )
                );

              }

              return Constante.circularLoader();
            },
          ),


        ),
      ),
    );

  }



  Widget ShowCheckButton() {
    return  InkWell(
      onTap: () async{
        if(formKey.currentState!.validate()){
          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await EditInfos(session.id,facebook.text, linkedin.text).then((value){
            print(value);
            if(value['result_code'].toString().contains("1")){
              Navigator.pop(context);
              Constante.showToastSuccess("Sauvegarde éffectué avec succès ",fToast);
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
          Constante.showToastError("Veuillez remplir les champs obligatoire ", fToast);
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:
          Icon(Icons.check, color: Colors.green,)
      ),

    );

  }



}