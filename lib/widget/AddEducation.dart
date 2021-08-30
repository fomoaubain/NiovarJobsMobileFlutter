import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/Global.dart'  as session;

import '../Constante.dart';

class AddEducation extends StatefulWidget {
  @override
  _AddEducation createState() => _AddEducation();
}

class _AddEducation extends State<AddEducation> {
  late FToast fToast;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController dateDebut = TextEditingController();

  TextEditingController dateFin = TextEditingController();

  TextEditingController etablissement = TextEditingController();

  TextEditingController diplome = TextEditingController();

  TextEditingController description = TextEditingController();

  late bool refresh=true;

  bool value = false;
  String date = "";
  DateTime selectedDateDebut = DateTime.now();
  DateTime selectedDateFin = DateTime.now();

  Future postEducation(var id, String etablissement, String diplomes, String periode, String description) async {
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestCV/SaveEducation";
    FormData formData = new FormData.fromMap({
      'Ins_id': id,
      'etablissement': etablissement,
      'diplome': diplomes,
      'periode': periode,
      'description': description,
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
            "Ajouter une éducation",
            style: Constante.kTitleStyle,
          ),
          centerTitle: true,
          actions: <Widget>[
            ShowCheckButton(),
          ],
        ),

      body:Container( margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Date de début',style: Constante.style4,),
                ),
                TextFormField(
                  controller: dateDebut,
                  obscureText: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: (){
                        _selectDateDebut(context);
                      },
                      icon: Icon(Icons.calendar_today_sharp),
                    ),
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
                    return null;
                  },

                ),
                SizedBox(height: 13,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Date de fin',style: Constante.style4,),
                ),
                TextFormField(
                  controller: dateFin,
                  obscureText: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                      onPressed: (){
                        _selectDateFin(context);
                      },
                      icon: Icon(Icons.calendar_today_sharp),
                    ),
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
                    return null;
                  },

                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Etablissement d'enseignement",style: Constante.style4,),
                ),
                TextFormField(
                  controller: etablissement,
                  obscureText: false,
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
                      return "Ce champ est obligatoire";
                    }
                    if(value.length>100){
                      return "maximum 100 caracteres";
                    }
                    return null;
                  },

                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Diplôme obtenu',style: Constante.style4,),
                ),
                TextFormField(
                  controller: diplome,
                  cursorColor: Colors.black,
                  maxLines: 2,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      hintText: "Saisir ici",
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
                    if(value!.length>200){
                      return "maximum 200 caracteres";
                    }
                    return null;
                  },
                  style: Constante.style4,
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Description',style: Constante.style4,),
                ),
                TextFormField(
                  controller: description,
                  cursorColor: Colors.black,
                  maxLines: 4,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      hintText: "Saisir ici",
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
                    if(value!.length>200){
                      return "maximum 200 caracteres";
                    }
                    return null;
                  },
                  style: Constante.style4,
                ),



              ],
            ),
          ),


        ),
      ),
    );

  }



   _selectDateDebut(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateDebut,
      firstDate: DateTime(1980),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDateDebut)
      setState(() {
        selectedDateDebut = selected;
        dateDebut.text="${selectedDateDebut.day<=9 ? "0"+selectedDateDebut.day.toString(): selectedDateDebut.day}/${selectedDateDebut.month<=9 ? "0"+selectedDateDebut.month.toString(): selectedDateDebut.month}/${selectedDateDebut.year}";
        dateFin.text="";
      });
  }

  _selectDateFin(BuildContext context) async {
     if(dateDebut.text.isEmpty){
       Constante.showToastError("Veuillez choisir la date de début ", fToast);
       return;
     }
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: selectedDateFin,
      firstDate: DateTime(1980),
      lastDate: DateTime(2050),
    );
    if (selected != null && selected != selectedDateFin){
      if(selected.compareTo(selectedDateDebut)<=0){
        Constante.showToastError("Veuillez choisir une date supérieur à la date de debut ", fToast);
        setState(() {
          dateFin.text="";
        });

        return ;
      }
      setState(() {
        selectedDateFin = selected;
        dateFin.text="${selectedDateFin.day<=9 ? "0"+selectedDateFin.day.toString(): selectedDateFin.day}/${selectedDateFin.month<=9 ? "0"+selectedDateFin.month.toString(): selectedDateFin.month}/${selectedDateFin.year}";
      });
    }

  }

  Widget ShowCheckButton() {
    return  InkWell(
      onTap: () async{
        if(formKey.currentState!.validate()){

          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await postEducation(session.id,etablissement.text,diplome.text,dateDebut.text+" au "+dateFin.text,description.text).then((value) async {
            if(value['result_code'].toString().contains("1")){
              Navigator.pop(context);
              Constante.showToastSuccess("Sauvegarde éffectué avec succès ",fToast);
              await new Future.delayed(new Duration(seconds: 2));
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