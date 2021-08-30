import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;

import 'homePage.dart';

class EditPwd extends StatefulWidget {

  @override
  _EditPwd createState() => _EditPwd();
}

class _EditPwd extends State<EditPwd> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController t1Controller = TextEditingController();
  TextEditingController pwd = TextEditingController();
  TextEditingController confirm_pwd = TextEditingController();

  Future editPassword(String id, String oldPassword, String pwd, String confirm_pwd) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/EditPasswordUser";
    FormData formData = new FormData.fromMap({
      "id": id,
      "oldPassword": oldPassword,
      "password": pwd,
      "confirmPassword": confirm_pwd,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }

  @override
  void initState() {
    super.initState();

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
          "Changer mot de passe",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),

        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                SizedBox(
                  height: 20,
                ),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Ancien mot de passe',style: Constante.style4,),
                ),

                TextFormField(
                  obscureText: true,
                  controller: t1Controller,
                  decoration: InputDecoration(
                    hintText: "Ancien mot de passe",
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
                      return "Ce champ est obligatoire";
                    }
                    if(value.length>50){
                      return "maximum 50 caracteres";
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Nouveau mot de passe',style: Constante.style4,),
                ),
                TextFormField(
                  obscureText: true,
                  controller: pwd,
                  decoration: InputDecoration(
                    hintText: "Nouveau mot de passe",
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
                      return "Ce champ est obligatoire";
                    }
                    if(value.length>10){
                      return "maximum 10 caracteres";
                    }
                    if(!RegExp(r"^(?:(?=.*?[A-Z])(?:(?=.*?[0-9])(?=.*?[-!@#$%^&*()_])|(?=.*?[a-z])(?:(?=.*?[0-9])|(?=.*?[-!@#$%^&*()_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%^&*()_]))[A-Za-z0-9!@#$%^&*()_]{8,10}$").hasMatch(value)){
                      return "minimum 8 caracteres, 1 majuscule, 1 minuscule et 1 chiffre numerique";
                    }
                    return null;
                  },

                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Confirmer mot de passe',style: Constante.style4,),
                ),
                TextFormField(
                  obscureText: true,
                  controller: confirm_pwd,
                  decoration: InputDecoration(
                    hintText: "Confirmer mot de passe",
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
                      return "Confirmer le mot de passe";
                    }
                    if(pwd.text != confirm_pwd.text){
                      return "Mot de passe de confirmation incorrect";
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 30,
                ),
                customButton('Sauvegarder')
              ],
            ),
          ),

        )

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
              Constante.showAlert(context, "Veuillez patientez", "Mofidification du mot de passe en cour...", SizedBox(), 100);
              await editPassword(session.id,t1Controller.text,pwd.text,confirm_pwd.text).then((value) async {
                if(value['result_code'].toString().contains("1")){
                  Navigator.pop(context);
                  Constante.showAlert(context, "Note d'information", "Mot de passe modifier avec succès", SizedBox(), 100);
                  await new Future.delayed(new Duration(seconds: 2));
                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                   prefs.clear();
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => homePage(title: "",)
                      ),
                      ModalRoute.withName("/Home")
                  );
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

              });

            }else{
              print("unsuccefully");
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