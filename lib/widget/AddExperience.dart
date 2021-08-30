import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart'  as session;

class AddExperience extends StatefulWidget {
  late int choix;
  AddExperience(this.choix);
  @override
  _AddExperience createState() => _AddExperience(this.choix);
}

class _AddExperience extends State<AddExperience> {
  late int choix;
  late FToast fToast;
  bool showDateFinTextFields=true;

  _AddExperience(this.choix);

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController dateDebut = TextEditingController();

  TextEditingController dateFin = TextEditingController();

  TextEditingController entreprise = TextEditingController();

  TextEditingController fonction = TextEditingController();

  TextEditingController description = TextEditingController();

  bool value = false;
  String date = "";
  DateTime selectedDateDebut = DateTime.now();
  DateTime selectedDateFin = DateTime.now();

  Future postExperience(var id, String etablissement, String fonction, String periode, String description, String enCour) async {
    Dio dio = new Dio();
     String pathUrl = Constante.serveurAdress+"RestCV/SaveExperience";
    if(choix==2){
      pathUrl = Constante.serveurAdress+"RestCV/SaveAutre";
    }

    FormData formData = new FormData.fromMap({
      'Ins_id': id,
      'etablissement': etablissement,
      'fonction': fonction,
      'periode': periode,
      'description': description,
      'enCour': enCour,
    });
    var response = await dio.post(pathUrl,
      data: await formData);
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
          "Ajouter une experience ",
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
                                 value ? showDateFinTextFields=false : showDateFinTextFields=true;
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
                        'Toujours en poste',
                        style: Constante.style4,
                      ), //Text
                    ], //<Widget>[]
                  ),
                ),
                SizedBox(height: 13,),
                showDateFinTextFields ? Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text('Date de fin',style: Constante.style4,),
                ) : SizedBox(),
                showDateFinTextFields ? TextFormField(
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

                ) : SizedBox(),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Text("Entreprise",style: Constante.style4,),
                ),
                TextFormField(
                  controller: entreprise,
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
                  child: Text('Fonction',style: Constante.style4,),
                ),
                TextFormField(
                  controller: fonction,
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

  Widget ShowCheckButton() {
    return  InkWell(
      onTap: () async{
        if(formKey.currentState!.validate()){
          String enCour="";
          String periode="";
          if(this.value){
            enCour="1";
            periode=dateDebut.text;
          }else{
            periode=dateDebut.text+" au "+ dateFin.text;
          }
          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await postExperience(session.id,entreprise.text,fonction.text,periode,description.text, enCour).then((value) async {
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
}