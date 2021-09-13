import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/animation/FadeAnimation.dart';
import 'package:niovarjobs/model/Job.dart';

import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/CodeVerificationPage.dart';
import 'package:niovarjobs/src/LoginPage.dart';

class form_client extends StatefulWidget {

  @override
  _form_client createState() => _form_client();
}

class _form_client extends State<form_client> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CA';
  PhoneNumber number = PhoneNumber(isoCode: 'CA');

  late String name, email, telephone;
  bool validateNumber=false;

  final TextEditingController pwd = TextEditingController();
  final TextEditingController confirm_pwd = TextEditingController();

  Future CreateCompte(String name, String email, String telephone, String pwd, String type ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/addUser";
    FormData formData = new FormData.fromMap({
      "login": name,
      "email": email,
      "password": pwd,
      "telephone": telephone,
      "type": type,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }

  @override
  Widget build(BuildContext context) {
    return  Container(

      child: ListView(
        children: <Widget>[
          SizedBox(height: 0.0),
          Container(
              alignment: Alignment.topCenter,
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
                      child: Column(
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Constante.makelabel("Nom de compagnie"),
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
                                  if(value.length>50){
                                    return "maximum 50 caracteres";
                                  }
                                  name= value;
                                  return null;
                                },
                                onSaved: (String ?  value){
                                  name = value!;
                                },
                              ),

                            ],
                          ),
                          SizedBox(height: 15,),
                          InternationalPhoneNumberInput(
                            onInputChanged: (PhoneNumber number) {
                              print(number.phoneNumber);
                              telephone = number.phoneNumber!;
                            },
                            onInputValidated: (bool value) {
                              validateNumber=value;
                            },
                            selectorConfig: SelectorConfig(
                              selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                            ),
                            ignoreBlank: false,
                            autoValidateMode: AutovalidateMode.disabled,
                            selectorTextStyle: TextStyle(color: Colors.black),
                            initialValue: number,
                            textFieldController: controller,
                            inputDecoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26)
                              ),
                              border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black26)
                              ),
                              hintText: 'Numero de telephone',
                            ),
                            formatInput: false,
                            keyboardType:
                            TextInputType.numberWithOptions(signed: true, decimal: true),
                            inputBorder: OutlineInputBorder(),
                            validator: (String ? value){
                              if(value!.isEmpty){
                                return "Ce champ est obligatoire";
                              }
                              if(!validateNumber){
                                return "Numero de telephone incorrect";
                              }
                              return null;
                            },

                          ),

                          SizedBox(height: 15,),
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
                                  if(value.length>50){
                                    return "maximum 50 caracteres";
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
                          SizedBox(height: 15,),
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
                                  if(value.length>10){
                                    return "maximum 10 caracteres";
                                  }
                                  if(!RegExp(r"^(?:(?=.*?[A-Z])(?:(?=.*?[0-9])(?=.*?[-!@#$%^&*()_])|(?=.*?[a-z])(?:(?=.*?[0-9])|(?=.*?[-!@#$%^&*()_])))|(?=.*?[a-z])(?=.*?[0-9])(?=.*?[-!@#$%^&*()_]))[A-Za-z0-9!@#$%^&*()_]{8,10}$").hasMatch(value)){
                                    return "minimum 8 caracteres, 1 majuscule, 1 minuscule et 1 chiffre numerique";
                                  }
                                  return null;
                                },

                              ),

                            ],
                          ),
                          SizedBox(height: 15,),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Constante.makelabel("Confirmer le mot de passe"),
                              SizedBox(height: 5,),
                              TextFormField(
                                controller: confirm_pwd,
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
                                    return "Confirmer le mot de passe";
                                  }
                                  if(pwd.text != confirm_pwd.text){
                                    return "Mot de passe de confirmation incorrect";
                                  }
                                  return null;
                                },

                              ),

                            ],
                          ),

                          FadeAnimation(1, Padding(
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
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
                                onPressed: () async {

                                  if(formKey.currentState!.validate()){
                                    Constante.showAlert(context, "Veuillez patientez", "Creation de votre compte en cour...", SizedBox(), 100);
                                    await CreateCompte(name, email, telephone, pwd.text, Constante.typeClient).then((value){
                                      if(value['result_code'].toString().contains("1")){
                                        String code=value['code'].toString();
                                        Navigator.pop(context);
                                        Navigator.push(
                                            context, MaterialPageRoute(builder: (context) => CodeVerificationPage(email, code, false)));
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
                                    print("unsuccefully");
                                  }
                                },
                                color: Colors.orange,
                                elevation: 4,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0)
                                ),
                                child: Text("Creer mon compte", style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                    color: Colors.white
                                ),),
                              ),
                            ),
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              )

          )

        ],
      ),
    );
  }

  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber, 'US');

    setState(() {
      this.number = number;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}


