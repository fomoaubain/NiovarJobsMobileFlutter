import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/src/PasswordForget.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import '../Global.dart';
import 'LoginPage.dart';

class CodeVerificationPage extends StatefulWidget {
  late  String email;
  late  String code;
  late bool ispasswordforget;
  CodeVerificationPage(this.email, this.code, this.ispasswordforget);
  @override
  _CodeVerificationPage createState() => _CodeVerificationPage();
}

class _CodeVerificationPage extends State<CodeVerificationPage> {
  late FToast fToast;

  TextEditingController textEditingController = TextEditingController();
  // ..text = "123456";

  // ignore: close_sinks
  StreamController<ErrorAnimationType>? errorController;

  bool hasError = false;
  String currentText = "";
  final formKey = GlobalKey<FormState>();

  Future VerifyEmail( String email) async{
    Dio dio = new Dio();
    String pathUrl ="";
    if(widget.ispasswordforget) {
      pathUrl = Constante.serveurAdress+"RestUser/ForgotPassword";
    }else{
      pathUrl = Constante.serveurAdress+"RestUser/sendCode";
    }
    var response = await dio.get(pathUrl,
        queryParameters: {'email': email}
    );
    return response.data;
  }

  Future confirmCompte( String email) async{
    Dio dio = new Dio();
    String  pathUrl = Constante.serveurAdress+"RestUser/Confirm";
    var response = await dio.get(pathUrl,
        queryParameters: {'email': email}
    );
    return response.data;
  }

  @override
  void initState() {
    errorController = StreamController<ErrorAnimationType>();
    super.initState();
    fToast = FToast();
    fToast.init(context);
  }

  @override
  void dispose() {
    errorController!.close();

    super.dispose();
  }

  // snackBar Widget
  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: Duration(seconds: 2),
      ),
    );
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

      body: GestureDetector(
        onTap: () {},
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: ListView(
            children: <Widget>[
              SizedBox(height: 20),

              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Text(
                  'Vérification de votre courriel',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                  textAlign: TextAlign.center,
                ),
              ),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 30.0, vertical: 8),
                child: RichText(
                  text: TextSpan(
                      text: "Entrer le code envoyer à cette adresse ",
                      children: [
                        TextSpan(
                            text: widget.email,
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15)),
                      ],
                      style: TextStyle(color: Colors.black54, fontSize: 15)),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Form(
                key: formKey,
                child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 30),
                    child: PinCodeTextField(
                      appContext: context,
                      pastedTextStyle: TextStyle(
                        color: Colors.orange.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                      length: 6,
                      obscureText: true,
                      obscuringCharacter: '*',
                      blinkWhenObscuring: true,
                      animationType: AnimationType.fade,
                      validator: (v) {
                        if (v!.length < 3) {
                          return "Veuillez saisir le code de confirmation";
                        } else {
                          return null;
                        }
                      },
                      pinTheme: PinTheme(
                        shape: PinCodeFieldShape.underline,
                        borderRadius: BorderRadius.circular(5),
                        fieldHeight: 50,
                        fieldWidth: 40,
                        activeFillColor: Colors.white,
                        inactiveFillColor: Colors.white54,
                      ),
                      cursorColor: Colors.black,
                      animationDuration: Duration(milliseconds: 300),
                      enableActiveFill: true,
                      errorAnimationController: errorController,
                      controller: textEditingController,
                      keyboardType: TextInputType.number,
                      boxShadows: [
                        BoxShadow(
                          offset: Offset(0, 1),
                          color: Colors.black12,
                          blurRadius: 10,
                        )
                      ],
                      onCompleted: (v) {

                      },
                      // onTap: () {
                      //   print("Pressed");
                      // },
                      onChanged: (value) {
                        print(value);
                        setState(() {
                          currentText = value;
                        });
                      },
                      beforeTextPaste: (text) {
                        print("Allowing to paste $text");
                        //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                        //but you can show anything you want here, like your pop up saying wrong paste format or etc
                        return true;
                      },
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Text(
                  hasError ? "* Code de confirmation invalide " : "",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Je n'ai pas reçus de mail ? ",
                    style: TextStyle(color: Colors.black54, fontSize: 15),
                  ),
                  TextButton(
                      onPressed: () async {
                        Constante.showAlert(context, "Veuillez patientez", "Envoie du courriel en cour en cour...", SizedBox(), 100);
                        await VerifyEmail(widget.email.toString()).then((value){
                          if(value['result_code'].toString().contains("1")){
                            Navigator.pop(context);
                            String code=value['code'].toString();
                            setState(() {
                            this.widget.code= code;
                            });
                            Constante.showToastSuccess("Un nouveau courriel de vérification vous à été envoyer ",fToast);
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
                      },
                      child: Text(
                        "Envoyer de nouveau",
                        style: TextStyle(
                            color: Color(0xFF91D3B3),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ))
                ],
              ),
              SizedBox(
                height: 14,
              ),
              Container(
                margin:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 30),
                child: ButtonTheme(
                  height: 50,
                  child: TextButton(
                    onPressed: () async {
                      formKey.currentState!.validate();
                      // conditions for validating
                      if (currentText.length != 6 || currentText != widget.code.toString()) {
                        errorController!.add(ErrorAnimationType
                            .shake); // Triggering error shake animation
                        setState(() => hasError = true);
                      } else {
                        setState(
                              () {
                            hasError = false;
                          },
                        );
                        if(widget.ispasswordforget){
                          Navigator.pop(context);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => PasswordForget(widget.email)));
                        }else{
                          Constante.showAlert(context, "Veuillez patientez", "Vérification en cour...", SizedBox(), 100);
                          await confirmCompte(widget.email.toString()).then((value){
                            if(value['result_code'].toString().contains("1")){
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => LoginPage()));
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
                      }
                    },
                    child: Center(
                        child: Text(
                          "VERIFIER".toUpperCase(),
                          style: Constante.kTitleStyle.copyWith(
                              color: Colors.white,
                              fontSize: 16.0,
                              fontWeight: FontWeight.w400
                          ),
                        )),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.orange.shade200,
                          offset: Offset(1, -2),
                          blurRadius: 5),
                      BoxShadow(
                          color: Colors.orange.shade200,
                          offset: Offset(-1, 2),
                          blurRadius: 5)
                    ]),
              ),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Flexible(
                      child: TextButton(
                        child: Text("Vider"),
                        onPressed: () {
                          textEditingController.clear();
                        },
                      )),

                ],
              )
            ],
          ),
        ),
      ),
    );

  }

}