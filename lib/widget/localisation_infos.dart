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
import 'package:niovarjobs/model/Type.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart'  as session;
class Localisation_infos extends StatefulWidget {


  @override
  _Localisation_infos createState() => _Localisation_infos();
}

class _Localisation_infos extends State<Localisation_infos> {
  late FToast fToast;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  late  final TextEditingController adresse;
  late final TextEditingController codePostal ;
  late final TextEditingController location = TextEditingController();
  late Future <Inscrire> currentInscrire;

  late Inscrire inscrire;

  late String countryValue;
  late String stateValue;
  late String cityValue;

   String pays="", province="", ville="";
   bool isLoading =false;


  Future<Inscrire> fetchItem() async {
    final responseInscrire = await http.get(Uri.parse(Constante.serveurAdress+"RestUser/getUser/"+session.id));
    if (responseInscrire.statusCode == 200) {
      final data = jsonDecode(responseInscrire.body)['user'];
      if (data != null) {
        inscrire = Inscrire.fromJson(data);
        adresse = TextEditingController(text: inscrire.adresse);
        codePostal = TextEditingController(text: inscrire.codePostal);
        setState(() {
          countryValue=inscrire.pays;
          stateValue=inscrire.province;
          cityValue=inscrire.ville;
              location.text=countryValue+", "+stateValue+", "+cityValue;
        });

      }
    }
    return inscrire;
  }


  Future EditInfos(var id, var adresse, var codePostal, var pays, var region, var ville) async {

    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Edit";
    FormData formData = new FormData.fromMap({
      'id': id,
      'code_postal': codePostal,
      'adresse': adresse,
      'pays': pays.toString().isNotEmpty ? pays.substring(8) : "",
      'province': region,
      'ville': ville,

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
          "Mon adresse",
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
                        Text("Adresse permanent", style: Constante.style4,),
                        SizedBox(height:size.height*0.01),
                        TextFormField(
                      cursorColor: Colors.black,
                      maxLines: 4,
                      controller: adresse,
                      decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                          hintText: "Adresse permanent",
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
                              return "";
                            }
                            if(value.length>200){
                              return "maximum 50 caracteres";
                            }
                            return null;
                          },
                      style: Constante.style4,
                    ),
                        SizedBox(height:size.height*0.03),
                        Row(
                          children: [
                            Expanded(child:
                            Text.rich(
                              TextSpan(
                                style:Constante.style4,
                                children: [
                                  WidgetSpan(
                                    child: Icon(Icons.location_on,color:Colors.black45, size: 22.0,),
                                  ),
                                  TextSpan(
                                    text: " Pays, région et ville",
                                  )
                                ],
                              ),
                            ),
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                                child: InkWell(
                                  onTap: () {
                                    showLocationdialog(context);
                                  },
                                  child: Icon(Icons.edit_outlined,color: Colors.green,size: 24,),
                                )
                            ),

                          ],
                        ),

                        SizedBox(height:size.height*0.02),
                        TextFormField(
                          controller: location,
                          cursorColor: Colors.black,
                          maxLines: 2,
                          readOnly: true,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                          style: Constante.style4,
                        ),

                        SizedBox(height:size.height*0.03),

                        Text("Code postal", style: Constante.style4,),
                        SizedBox(height:size.height*0.01),
                        TextFormField(
                          obscureText: false,
                          controller: codePostal,
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
                            if(value!.length>100){
                              return "maximum 100 caracteres";
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
          setState(() {isLoading= true;});

          await EditInfos(session.id,adresse.text, codePostal.text, pays, province, ville).then((value){
            setState(() {isLoading= false;});
            if(value['result_code'].toString().contains("1")){
              pays=""; province=""; ville=""; countryValue =""; stateValue=""; cityValue="";
              Constante.showToastSuccess("Sauvegarde éffectué avec succès ",fToast);
            }else{
              Constante.AlertMessageFromRequest(context,value['message'].toString());
            }
          }
          ).catchError((error){
            setState(() {
              isLoading=false;
              Constante.AlertInternetNotFound(context);
            });
          });
        }else{
          Constante.showToastError("Veuillez remplir les champs obligatoire ", fToast);
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: (isLoading)
              ? MaterialButton(
              minWidth: 20,
              height: 20,
              onPressed: () {  },
              child:const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    color: Colors.orange,
                    strokeWidth: 1.5,
                  ))
          )
              : Icon(Icons.check, color: Colors.green,)
      ),

    );
  }

   showLocationdialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 5,),
                CSCPicker(
                  onCountryChanged: (value) {
                    setState(() {
                      countryValue = value;

                    });
                  },
                  onStateChanged:(value) {
                    setState(() {
                      stateValue=value;
                    });
                  },
                  onCityChanged:(value) {
                    setState(() {
                      cityValue = value;
                    });
                  },
                ),

                SizedBox(height: 10,),
                SizedBox(
                  child: RaisedButton(
                    padding: EdgeInsets.all(10),
                    onPressed: () {
                      if(countryValue.isNotEmpty && stateValue.isNotEmpty && cityValue.isNotEmpty){
                        setState(() {
                          location.text=countryValue+", "+stateValue+", "+cityValue;
                          pays=countryValue;
                          ville=cityValue;
                          province=stateValue;
                        });
                        Navigator.pop(context);
                      }
                    },
                    child: Text(
                      "Terminer",
                      style: TextStyle(color: Colors.white),
                    ),
                    color:Colors.green,
                  ),
                ),
              ],
            ),
          ),


        ),
      ),
    );
  }



}