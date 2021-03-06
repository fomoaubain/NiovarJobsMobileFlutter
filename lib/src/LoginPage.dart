
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/animation/FadeAnimation.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/src/CreateUser.dart';
import 'package:niovarjobs/src/VerifyEmailPage.dart';
import 'package:niovarjobs/src/homePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;


class LoginPage extends StatefulWidget {

  @override
  _LoginPage createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage>  {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  late String  email;
  final TextEditingController pwd = TextEditingController();
  bool isLoading = false;

  @override
 void initState()  {
    super.initState();
  }

  Future Login( String email,  String pwd) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Login";
    FormData formData = new FormData.fromMap({
      "email": email,
      "password": pwd,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );
    return response.data;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
        centerTitle: true,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: double.infinity,
        // margin: EdgeInsets.only(top: 50.0),
        padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40.0),
            topRight: Radius.circular(40.0),
          ),
        ),
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        FadeAnimation(1,
                            Text("Se connecter", style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold
                        ),)
                        ),
                        SizedBox(height: 20,),
                        FadeAnimation(1, Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Vous n'avez pas de compte ?"),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                Navigator.push(
                                    context, MaterialPageRoute(builder: (context) => CreateUser()));
                              },
                              child:    Text(" Creer un compte", style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 15, color: Colors.orange
                              ),),
                            ),

                          ],
                        ))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Constante.makelabel("Courriel"),
                              SizedBox(height: 5,),
                              TextFormField(
                                obscureText: false,
                                decoration: InputDecoration(
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
                                  email = value;
                                  return null;
                                },

                                onSaved: (String ? name){
                                  email = name!;
                                },
                              ),

                            ],
                          ),
                          SizedBox(height: 20,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Constante.makelabel("Mot de passe"),
                              SizedBox(height: 5,),
                              TextFormField(
                                controller: pwd,
                                obscureText: true,
                                decoration: InputDecoration(
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
                                  return null;
                                },

                              ),

                            ],
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => VerifyEmailPage()));
                      },
                      child:Text("Mot de passe oubliez ?", style: TextStyle(color: Colors.grey),),

                    ),

                    FadeAnimation(1, Padding(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 0),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12.0),
                            border: Border(
                              bottom: BorderSide(color: Colors.white54),
                              top: BorderSide(color: Colors.white54),
                              left: BorderSide(color: Colors.white54),
                              right: BorderSide(color: Colors.white54),
                            )
                        ),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          height: 60,
                          onPressed: () async{
                            if(formKey.currentState!.validate()){
                              print("Token : "+ session.fcmToken);
                              setState(() {
                                isLoading=true;
                              });
                              await Login( email, pwd.text).then((value) async {
                                setState(() {
                                  isLoading = false;
                                });
                                if(value['result_code'].toString()=="1"){
                                  Inscrire inscrire = Inscrire.fromJson(value['user']);
                                  final SharedPreferences prefs = await SharedPreferences.getInstance();
                                  if(inscrire!=null){
                                    prefs.setString('login', inscrire.login);
                                    prefs.setString('id', inscrire.id.toString());
                                    prefs.setString('email', inscrire.email);
                                    prefs.setString('type', inscrire.type);
                                    prefs.setString('token', value['token'] != null ? value['token']:"ras");
                                    prefs.setString('profil', inscrire.type=="client" ? inscrire.profilCompagnie: inscrire.profilName);
                                  }

                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => homePage(title: "",)
                                      ),
                                      ModalRoute.withName("/Home")
                                  );
                                }else{
                                  Constante.AlertMessageFromRequest(context,value['message'].toString());
                                }
                              }).catchError((error){
                                print(error.toString());
                                setState(() {
                                  isLoading=false;
                                  Constante.AlertInternetNotFound(context);
                                });
                              });
                            }else{
                              print("unsuccefully");
                            }
                          },
                          color: Colors.orange,
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)
                          ),
                          child: (isLoading)
                              ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 1.5,
                              ))
                              :  Text("Se connecter", style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: Colors.white
                          ),),
                        ),
                      ),
                    )),
                   // FadeAnimation(1, Text("Continuer avec les r??seaux sociaux", style: TextStyle(color: Colors.grey),)),

                    /*Padding(padding: EdgeInsets.symmetric(horizontal: 50),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Container(
                                child: Image.asset("assets/google-logo.png", height: 50,),
                              )
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                              child: Container(
                                child: Image.asset("assets/Facebook-logo.png", height: 50,),
                              )
                          ),
                        ],
                      ),
                    ),*/

                  ],
                ),
              ),

            ],
          ),
        )

      ),
    );
  }


}