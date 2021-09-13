import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Information.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/widget/AddEducation.dart';
import 'package:niovarjobs/widget/AddExperience.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart'  as session;

class CvPage extends StatefulWidget {

  @override
  _CvPage createState() => _CvPage();
}

class _CvPage extends State<CvPage> {
 bool refresh = false;
  late FToast fToast;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController presentattion = TextEditingController();

  TextEditingController competences = TextEditingController();
  List<String> mesComptences = [];
  List<String> initmesComptences = [];

  bool _showLoading = true;
  List<Education> listEducation = [];
  List<Autre> listAutre = [];
  List<Experiences> listEsperience = [];
  int sizeEducation =0;




  int _currentStep = 0;

  tapped(int step) {
    setState(() => _currentStep = step);
  }

  continued() {
    _currentStep < 2 ? setState(() => _currentStep += 1) : null;
  }

  cancel() {
    _currentStep > 0 ? setState(() => _currentStep -= 1) : null;
  }

  StepperType stepperType = StepperType.vertical;

  Future _fetchData(String id) async {
    Information information;
    final responsePostuler = await http.get(Uri.parse(Constante.serveurAdress+"RestCV/CvResume/"+id.toString()));
    if (responsePostuler.statusCode == 200) {
      final informationResponse = jsonDecode(responsePostuler.body)['information'];
      final education = jsonDecode(responsePostuler.body)['education'];
      final experiences = jsonDecode(responsePostuler.body)['experiences'];
      final autres = jsonDecode(responsePostuler.body)['autres'];

      setState(() {
        if(informationResponse!=null){
          information= Information.fromJson(informationResponse);
          if(information.lettre.toString().isNotEmpty){
            presentattion.text= information.lettre.toString();
          }

          if(information.competence.toString().isNotEmpty){
            information.competence.toString().split(',').forEach((element) {
              mesComptences.add(element);
            });

          }

        }

        if(education!=null){
          education.forEach((element) {
            listEducation.add(Education.fromJson(element));
          });
          sizeEducation = listEducation.length;
        }

        if(experiences!=null){
          experiences.forEach((element) {
            listEsperience.add(Experiences.fromJson(element));
          });
        }

        if(autres!=null){
          autres.forEach((element) {
            listAutre.add(Autre.fromJson(element));
          });
        }
        _showLoading = false;
      });
    }
  }

  Future postInfos(var id, String lettre, String competences) async {

    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestCV/SaveInformation";
    FormData formData = new FormData.fromMap({
      'Ins_id': id,
      'lettre': lettre,
      'competence': competences,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    _fetchData(session.id);
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
          "Mon CV",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          ShowCheckButton(),
        ],
      ),

      body: Container(
    height: double.infinity,
    width: double.infinity,
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
    child: SingleChildScrollView(
    child: _showLoading ? Constante.circularLoader() : Form (
      key: formKey,
      child:   Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Lettre de présentation',
              style: Constante.style4,
            ),
          ),
          TextFormField(
            controller: presentattion,
            cursorColor: Colors.black,
            maxLines: 7,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                hintText: 'veuillez saisir ici',
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
            validator: (String ? value){
              if(value!.isEmpty){
                return "Ce champ est obligatoire";
              }
              return null;
            },

          ),
          SizedBox(
            height: 13,
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Text(
              'Mes compétences',
              style: Constante.style4,
            ),
          ),
          Container(
              child: TextFieldTags(
                  tagsStyler: TagsStyler(
                      tagTextStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.white),
                      tagDecoration: BoxDecoration(color: Colors.orange[300], borderRadius: BorderRadius.circular(20), ),
                      tagCancelIcon: Icon(Icons.cancel, size: 18.0, color: Colors.red[400]),
                      tagPadding: const EdgeInsets.all(6.0)
                  ),
                  textSeparators: [","],
                  initialTags: mesComptences,
                  textFieldStyler: TextFieldStyler(
                      hintText: "Exemple : CSS, JS, HTML",
                      helperText: "Tapez entrer pour aller au suivant"
                  ),
                  onTag: (tag) {
                   mesComptences.add(tag);
                  },
                  onDelete: (tag) {
                    mesComptences.remove(tag);
                  },
                  validator: (tag){
                    if(tag.length>15){
                      return "maximum 15 caratères";
                    }
                    print('value: $tag');
                    return null;
                  }
              )
          ),

          SizedBox(
            height: 20,
          ),

          ExpansionTile(
            title: Row(
              children: [
                Container(
                  height:20,width: 20,
                  decoration: BoxDecoration(
                    color: Constante.kOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('1',style: TextStyle(fontSize: 10,color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Education",
                      style: Constante.kPageTitleStyle.copyWith(fontSize: 20)
                  ),
                ),
              ],
            ),
            trailing: Container(width:60,child:  customButton("Ajouter >>",() {
              goToSecondScreen(context, MaterialPageRoute(builder: (context) => AddEducation()));
            })),
            iconColor: Constante.primaryColor,
            collapsedIconColor:Constante.primaryColor,
            textColor: Constante.kBlack,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: listEducation.length==0 ? Text("Aucune donnée disponible") : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listEducation.length,
                          itemBuilder: (context,i){
                            return makeListEducation( listEducation[i], i);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Row(
              children: [
                Container(
                  height:20,width: 20,
                  decoration: BoxDecoration(
                    color: Constante.kOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('2',style: TextStyle(fontSize: 10,color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Expérience\nprofessionnelles",
                      style: Constante.kPageTitleStyle.copyWith(fontSize: 20)
                  ),
                ),
              ],
            ),
            trailing: Container(width:60,child:  customButton("Ajouter >>",() {
              goToSecondScreen(context, MaterialPageRoute(builder: (context) => AddExperience(1)));
            })),
            iconColor: Constante.primaryColor,
            collapsedIconColor:Constante.primaryColor,
            textColor: Constante.kBlack,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: listEsperience.length==0 ? Text("Aucune donnée disponible") : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listEsperience.length,
                          itemBuilder: (context,i){
                            return makeListExperience( listEsperience[i], i);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          ExpansionTile(
            title: Row(
              children: [
                Container(
                  height:20,width: 20,
                  decoration: BoxDecoration(
                    color: Constante.kOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Center(child: Text('3',style: TextStyle(fontSize: 10,color: Colors.white),)),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      "Autres\nexpériences",
                      style: Constante.kPageTitleStyle.copyWith(fontSize: 20)
                  ),
                ),
              ],
            ),
            trailing: Container(width:60,child:  customButton("Ajouter >>",() {
              goToSecondScreen(context, MaterialPageRoute(builder: (context) =>AddExperience(2)));
            })),
            iconColor: Constante.primaryColor,
            collapsedIconColor:Constante.primaryColor,
            textColor: Constante.kBlack,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      child: listAutre.length==0 ? Text("Aucune donnée disponible") : ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: listAutre.length,
                          itemBuilder: (context,i){
                            return makeListAutre( listAutre[i], i);
                          }
                      ),
                    ),
                  ],
                ),
              ),
            ],
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
          String competencesVal ="";
          mesComptences.forEach((element) {
            competencesVal+= element+",";
          });
          if ((competencesVal != null) && (competencesVal.length> 0)){
          competencesVal=  competencesVal.substring(0, competencesVal.length - 1);
          }

          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await postInfos(session.id,presentattion.text,competencesVal).then((value){
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

        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:
          Icon(Icons.check, color: Colors.green,)
      ),
    );
  }

  ListTile makeListEducation(Education item, int position) => ListTile(
    contentPadding:
    EdgeInsets.symmetric( vertical: 5.0),
    title: Text(
      item.etablissement+' du ' + item.periode,
      style: Constante.style7,
    ),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 12,
            child: Container(
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: Constante.style8,
                      children: [
                        TextSpan(
                          text: item.description,
                        )
                      ],
                    ),
                  ),
                ],
              ),

            )),


      ],
    ),
    trailing: InkWell(
      onTap: (){
        Constante.showAlert(context, "Alerte !", "Voulez-vous vraiment supprimer cette education ?",
            SizedBox(
              child: RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pop(context);
                  removeItem(item.id.toString(), 1, position);
                },
                child: Text(
                  "Oui",
                  style: TextStyle(color: Colors.white),
                ),
                color:Colors.redAccent,
              ),
            ),
            170);
      },
      child: Icon(Icons.delete, color: Colors.red, size: 30.0),
    ),
  );
  ListTile makeListExperience(Experiences item,int position){
    String DateFin="";
    if(item.enCour.toString().isNotEmpty && item.enCour.toString()=="1"){
      DateFin=" en poste";
    }
    return ListTile(
      contentPadding:
      EdgeInsets.symmetric( vertical: 5.0),
      title: Text(
          item.etablissement+" du " + item.periode+" "+ DateFin,
      style: Constante.style7,
    ),
    subtitle: Row(
    children: <Widget>[
    Expanded(
    flex: 12,
    child: Container(
    child : Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
    Text.rich(
    TextSpan(
    style: Constante.style8,
    children: [
    TextSpan(
    text: item.fonction.toString() +",\n" + item.description.toString(),
    )
    ],
    ),
    ),
    ],
    ),

    )),


    ],
    ),
    trailing: InkWell(
      onTap: (){
        Constante.showAlert(context, "Alerte !", "Voulez-vous vraiment supprimer cette expérience ?",
            SizedBox(
              child: RaisedButton(
                padding: EdgeInsets.all(10),
                onPressed: () {
                  Navigator.pop(context);
                  removeItem(item.id.toString(), 3, position);
                },
                child: Text(
                  "Oui",
                  style: TextStyle(color: Colors.white),
                ),
                color:Colors.redAccent,
              ),
            ),
            170);
      },
    child: Icon(Icons.delete, color: Colors.red, size: 30.0),
    ),
    );
  }

 ListTile makeListAutre(Autre item, int position){
   String DateFin="";
   if(item.enCour.toString().isNotEmpty && item.enCour.toString()=="1"){
     DateFin=" en poste";
   }
   return ListTile(
     contentPadding:
     EdgeInsets.symmetric( vertical: 5.0),
     title: Text(
       item.etablissement+" du " + item.periode+" "+ DateFin,
       style: Constante.style7,
     ),
     subtitle: Row(
       children: <Widget>[
         Expanded(
             flex: 12,
             child: Container(
               child : Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   Text.rich(
                     TextSpan(
                       style: Constante.style8,
                       children: [
                         TextSpan(
                           text: item.fonction.toString() +",\n" + item.description.toString(),
                         )
                       ],
                     ),
                   ),
                 ],
               ),

             )),


       ],
     ),
     trailing: InkWell(
       onTap: (){
         Constante.showAlert(context, "Alerte !", "Voulez-vous vraiment supprimer cette expérience ?",
             SizedBox(
               child: RaisedButton(
                 padding: EdgeInsets.all(10),
                 onPressed: () {
                   Navigator.pop(context);
                   removeItem(item.id.toString(), 2, position);
                 },
                 child: Text(
                   "Oui",
                   style: TextStyle(color: Colors.white),
                 ),
                 color:Colors.redAccent,
               ),
             ),
             170);
       },
       child: Icon(Icons.delete, color: Colors.red, size: 30.0),
     ),
   );
 }

  void goToSecondScreen(BuildContext context, Route route) async{
    bool dataFromSecondPage = await Navigator.push(
        context,route);
    setState(() {
      refresh = dataFromSecondPage;
      if(refresh){
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => super.widget));
      }
    });
  }

 void removeItem(String id, int choix, int position ) async {
    String url ="";
    if(choix==1) url= "RestCV/deleteEducation?id="+id;
    if(choix==2) url= "RestCV/deleteAutre?id="+id;
    if(choix==3) url="RestCV/deleteExperience?id="+id;
   Constante.showAlert(context, "Veuillez patientez", "Suppréssion en cour...", SizedBox(), 100);
   await deleteItem(id,url).then((value){
     if(value['result_code'].toString()=="1"){
       Navigator.pop(context);
       setState(() {
         if(choix==1) listEducation.removeAt(position);
         if(choix==2) listAutre.removeAt(position);
         if(choix==3) listEsperience.removeAt(position);
       });
       Constante.showToastSuccess("Supprimer avec succès ",fToast);
     }else{
       Navigator.pop(context);
       Constante.showAlert(context, "Alerte !", value['message'].toString(),
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
               color:Colors.redAccent,
             ),
           ),
           170);
     }

   }
   );

 }

 Future deleteItem(String id, String url) async{
   Dio dio = new Dio();
   final String pathUrl = Constante.serveurAdress+url;
   var response = await dio.get(pathUrl);
   return response.data;
 }

 Widget customButton(text,function){
   return Card(
       elevation: 10,
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(15),
       ),
       color: Colors.orange,
       child: InkWell( onTap: function,
         child: Container(
           height: 35,
           width: double.infinity,
           child: Center(
             child: Icon(Icons.add, color: Colors.white,)
           ),
         ),
         borderRadius: BorderRadius.circular(10),
       )
   );
 }
}