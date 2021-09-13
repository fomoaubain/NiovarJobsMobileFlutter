import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:csc_picker/csc_picker.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:niovarjobs/model/Categorie.dart';
import 'package:niovarjobs/model/Experience.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:niovarjobs/model/Type.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart'  as session;
class AddAvis extends StatefulWidget {
  Pages pages;
  AddAvis(this.pages);
  @override
  _AddAvis createState() => _AddAvis();
}

class _AddAvis extends State<AddAvis> {
  late FToast fToast;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late  final TextEditingController message = TextEditingController();


  Future AddAvis(String Pag_id, String libelle, String iduser ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestPage/addAvis";
    FormData formData = new FormData.fromMap({
      "Pag_id": Pag_id,
      "libelle": libelle,
      "iduser": iduser,

    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }

  @override
  void initState() {
    super.initState();
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
          "Laisser un avis",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height:size.height*0.02),
                  Text("Saisir votre avis ici", style: Constante.style4,),
                  SizedBox(height:size.height*0.01),
                  TextFormField(
                    cursorColor: Colors.black,
                    maxLines: 6,
                    controller: message,
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        hintText: "saisir ici",
                        hintStyle: Constante.style5,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Constante.kBlack),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide(color: Constante.kBlack.withOpacity(0.3)),
                        )
                    ),
                    validator: (String ? value){
                      if(value!.isEmpty){
                        return "Veuillez saisir un messages";
                      }
                      if(value.length>250){
                        return "Votre message est trop long";
                      }
                      return null;
                    },
                    style: Constante.style4,
                  ),
                  SizedBox(height: 40,),
                  customButton("Envoyer"),


                ],
              )
          ),


        ),
      ),
    );

  }


  Widget customButton(text){
    return InkWell(
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.orange,
          child: InkWell( onTap: () async {
            if(formKey.currentState!.validate()){
              Constante.showAlert(context, "Veuillez patientez", "Envoie du message en cour...", SizedBox(), 100);
              await AddAvis(widget.pages.id.toString(), message.text, session.id.toString()).then((value) async {
                if(value['result_code'].toString().contains("1")){
                  Navigator.pop(context);
                  Constante.showToastSuccess("Avis en attente de validation par la compagnie.", fToast);
                  await new Future.delayed(new Duration(seconds: 2));
                  Navigator.pop(context);
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
            }
          },
            child: Container(
              height: 55,
              width: double.infinity,
              child: Center(
                child: Text(text,style: Constante.kTitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400
                ),),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

  }








}