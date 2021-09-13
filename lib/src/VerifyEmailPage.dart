import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:niovarjobs/src/CodeVerificationPage.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class VerifyEmailPage extends StatefulWidget {
  @override
    _VerifyEmailPage createState() => _VerifyEmailPage();
}

class _VerifyEmailPage extends State<VerifyEmailPage> {

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();

  Future VerifyEmail( String email) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/ForgotPassword";
    var response = await dio.get(pathUrl,
        queryParameters: {'email': email}
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
          "Réinitialiser mon mot de passe",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Container( margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: SingleChildScrollView(
          child:Form(
            key: formKey,
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Mot de passe oublié ?',
                  style: Constante.style4.copyWith(fontSize: 25),
                ),
                SizedBox(height: 10,),
                Text(
                  "Entrez l'adresse courriel associée à votre compte NiovarJobs ci-dessous. Vous recevrez un courriel avec un code de vérification pour réinitialiser votre mot de passe",
                  style: Constante.style4.copyWith(fontSize: 16),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Courriel',style: Constante.style4,),
                ),
                TextFormField(
                  controller: email,
                  obscureText: false,
                  decoration: InputDecoration(
                    hintText: "Saisir ici",
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
                SizedBox(height: 50,),

                customButton("Réinitialiser mon mot de passe"),


              ],
            ),
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

              Constante.showAlert(context, "Veuillez patientez", "Vérification du courriel en cour...", SizedBox(), 100);
              await VerifyEmail(email.text).then((value){
                if(value['result_code'].toString().contains("1")){
                  Navigator.pop(context);
                  Navigator.pop(context);
                  String code=value['code'].toString();
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => CodeVerificationPage(email.text, code, true)));

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