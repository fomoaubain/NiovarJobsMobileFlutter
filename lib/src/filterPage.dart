import 'dart:async';
import 'dart:convert';
import 'dart:io';


import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:group_button/group_button.dart';
import 'package:niovarjobs/Global.dart';
import 'package:niovarjobs/model/Categorie.dart';
import 'package:niovarjobs/model/Experience.dart';
import 'package:niovarjobs/model/HoraireTravail.dart';
import 'package:niovarjobs/model/Type.dart';
import 'package:niovarjobs/widget/filter_pressed-Button.dart';
import 'package:niovarjobs/widget/group_Buttons.dart';
import 'package:niovarjobs/widget/slider_filter.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../Constante.dart';
import 'ResultatPage.dart';

class FilterPage extends StatefulWidget {
  @override
  _FilterPage createState() => _FilterPage();
}

class _FilterPage extends State<FilterPage> {

  String idCat="", idEmploi="", annexp="", horaireTravail="", vedette="", hour="", urgent="";

  final TextEditingController lieu = TextEditingController();

  String dropdownValue = 'One';
  String tempTravail = 'Aucun choix';
  String dateAffichage = 'Aucun choix';
  String titreEmploi="Aucun choix";
  String S3 = 'Aucun choix';
  late String selectCategorie='Aucun choix';

  late Future<List<Types>> listCategorie;
  late List<Types> listCategorieData=[];
  late List<Categorie> listTitreEmploi=[];
  late List<Experience> listExperience=[];
  late List<HoraireTravail> listHoraireTravail=[];

  late int idCategorie;
  List<String> listCategorieId=[];
  List<String> listCategorieLibelle=["Aucun choix"];
  List<String> listTitreEmploiLibelle=["Aucun choix"];
  List<String> listTitreEmploiId=[];

   Future<List<Types>> fetchItem(String urlApi) async {
     List<Types> listModel = [];
     List<Experience> listModelExperience = [];
     List<HoraireTravail> listModelHoraireTravail= [];
     final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
     if (response.statusCode == 200) {
       final data = jsonDecode(response.body)['datas'];
       if (data != null) {
         data.forEach((element) {
           listModel.add(Types.fromJson(element));
         });
       }
     }

     final responseExperience = await http.get(Uri.parse(Constante.serveurAdress+"RestJob/GetAllAnneeExp"));
     if (responseExperience.statusCode == 200) {
       final data = jsonDecode(responseExperience.body)['datas'];
       if (data != null) {
         data.forEach((element) {
           listModelExperience.add(Experience.fromJson(element));
         });
       }
     }

     final responseHoraireTravail = await http.get(Uri.parse(Constante.serveurAdress+"RestJob/GetAllHoraireTravail"));
     if (responseHoraireTravail.statusCode == 200) {
       final data = jsonDecode(responseHoraireTravail.body)['datas'];
       if (data != null) {
         data.forEach((element) {
           listModelHoraireTravail.add(HoraireTravail.fromJson(element));
         });
       }
     }

     setState(() {
       listHoraireTravail =listModelHoraireTravail.toList();
       listExperience = listModelExperience.toList();
       listCategorieId.add("Aucun choix");
       listModel.forEach((element) {
         listCategorieId.add(element.id.toString());
         listCategorieLibelle.add(element.libelle);
       });

     });




     return listModel;
   }


  Future FindTitreEmploi(int id ) async{
    final String pathUrl = Constante.serveurAdress+"RestJob/GetAllTitreEmploi/"+id.toString();
    print(pathUrl);
    final response = await http.get(Uri.parse(pathUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      return data;
    }else{
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    listCategorie= this.fetchItem('RestJob/GetAllTypes') ;
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
          "Recherche avancée",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          InkWell(
          onTap: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => super.widget));
            },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 6),
        child: Icon(Icons.refresh)
      ),

    )
        ],
      ),
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child: FutureBuilder<List<Types>>(
            future: listCategorie,
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
                listCategorieData = snapshot.data ?? [];

                return  Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Categorie",
                      style: Constante.style4,
                    ),
                    SizedBox(height: size.height*0.01,),
                    SelectCategorie(),
                    SizedBox(height:size.height*0.02),
                    Text(
                      "Offres urgentes",
                      style: Constante.style4,
                    ),
                    SizedBox(height: size.height*0.01,),
                    groupButtonsUrgente(context),
                    SizedBox(height: size.height*0.01,),
                    Text(
                      "Ville ou lieu",
                      style: Constante.style4,
                    ),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                     obscureText: false,
                      controller: lieu,
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
                    ),

                    SizedBox(height:size.height*0.03),
                    Text(
                      "Année d'experience",
                      style: Constante.style4,
                    ),
                    groupButtonsExperience(context),
                    SizedBox(height: size.height*0.03,),
                    Text(
                      "Horaire de travail",
                      style: Constante.style4,
                    ),
                    groupButtonsHoraireTravail(context),
                    SizedBox(height: size.height*0.02,),

                    Text(
                      "Offre en vedette",
                      style: Constante.style4,
                    ),
                    SizedBox(height: size.height*0.01,),
                    groupButtonsVedette(context),
                    SizedBox(height: size.height*0.03,),

                    Text(
                      "Date d'affichage",
                      style: Constante.style4,
                    ),
                    SelectDateAffichage(),


                  ],
                );
              }

              return Constante.circularLoader();
            },
          ),


        ),
      ),

      bottomNavigationBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: Container(
          padding: EdgeInsets.only(left: 18.0, bottom: 10.0, right: 18.0),
          // margin: EdgeInsets.only(bottom: 25.0),
          color: Colors.white,
          child: Row(
            children: <Widget>[
              Expanded(
                child: SizedBox(
                  height: 50.0,
                  child: RaisedButton(
                    onPressed: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ResultatPage(
                        lieu: lieu.text,
                        urgent: urgent,
                        annexp: annexp,
                        horaireTravail: horaireTravail,
                        vedette: vedette,
                        hour: hour,
                        idCat: idCat,
                      )));
                    },
                    color: Colors.orange[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      "Recherchez",
                      style: Constante.kTitleStyle.copyWith(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );

  }

   /*SelectTitreEmploi(){
     return Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(15),
         border: Border.all(color: Constante.kBlack.withOpacity(0.2)),
       ),
       margin: EdgeInsets.symmetric(vertical: 10),
       child: Padding(
         padding: const EdgeInsets.only(left: 5, right: 20, top: 5),
         child: Row(
           children: [
             Expanded(
               child: DropdownButton<String>(
                 value:titreEmploi,
                 icon: Padding(
                   padding: const EdgeInsets.only(right: 16),
                   child: const Icon(Icons.keyboard_arrow_down_outlined),
                 ),
                 iconSize: 24,
                 elevation: 16,
                 style: const TextStyle(color: Colors.deepPurple),
                 underline: Container(
                   height: 0,
                   color: Colors.deepPurpleAccent,
                 ),
                 onChanged: ( newValue) {
                   listTitreEmploi.forEach((element){
                     if(newValue== element.libelle){
                       idEmploi= element.id.toString();
                     }
                   });
                   setState(() {
                     titreEmploi = newValue!;
                   });
                 },
                 isExpanded: true,
                 items:listTitreEmploiLibelle.map<DropdownMenuItem<String>>((String value) {
                   return DropdownMenuItem<String>(
                       value: value,
                       child:ItemDropmenu(value)
                   );
                 }).toList(),
               ),
             ),
           ],
         ),
       ),
     );
   }*/

  SelectCategorie(){
   return DropdownSearch<String>(
        dropdownSearchDecoration: InputDecoration(
          hintText: "Sélectionnez la catégorie",
          contentPadding: EdgeInsets.fromLTRB(12, 5, 0, 0),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(width: 1, color: Constante.kBlack.withOpacity(0.2)),
            borderRadius: BorderRadius.circular(10.0)
          ),
        ),
        mode: Mode.MENU,
        items: listCategorieLibelle,
        validator: (v) => v == null ? "required field" : null,
        showSearchBox: true,
        onChanged: (newValue){
          listCategorieData.forEach((element){
            if(newValue== element.libelle){
              newValue = element.libelle;
              idCat=element.id.toString();
            }
          });
          setState(() {
            selectCategorie = newValue!;
          });
        },
        selectedItem: selectCategorie);

  }

   /*SelectCategorie(){
     return Container(
       decoration: BoxDecoration(
         borderRadius: BorderRadius.circular(15),
         border: Border.all(color: Constante.kBlack.withOpacity(0.2)),
       ),
       margin: EdgeInsets.symmetric(vertical: 10),
       child: Padding(
         padding: const EdgeInsets.only(left: 5, right: 20, top: 5),
         child: Row(
           children: [

             Expanded(
               child: DropdownButton<String>(
                 hint: Text('Selectionnez la categorie'),
                 value: categorie,
                 icon: Padding(
                   padding: const EdgeInsets.only(right: 16),
                   child: const Icon(Icons.keyboard_arrow_down_outlined),
                 ),
                 iconSize: 24,
                 elevation: 16,
                 style: const TextStyle(color: Colors.deepPurple),
                 underline: Container(
                   height: 0,
                   color: Colors.deepPurpleAccent,
                 ),
                 onChanged: ( newValue) async{
                   listCategorieData.forEach((element){
                     if(newValue== element.libelle){
                       newValue = element.libelle;
                       idCategorie= element.id;
                       idCat=element.id.toString();
                     }
                   });
                   setState(() {
                     categorie = newValue!;
                     if(categorie=="Aucun choix"){
                       titreEmploi="Aucun choix";
                       listTitreEmploiLibelle.clear();
                       listTitreEmploiLibelle.add("Aucun choix");
                       idCat=""; idEmploi="";
                       return;
                     }
                     Constante.showAlert(context, "Veuillez patientez", "Chargement des titres d'emploi...", SizedBox(), 100);
                     FindTitreEmploi(idCategorie).then((value){
                       if(value!=null){
                         listTitreEmploi.clear();
                         value.forEach((element) {
                           listTitreEmploi.add(Categorie.fromJson(element));
                         });
                         setState(() {
                           titreEmploi=listTitreEmploi.first.libelle;
                           idEmploi= listTitreEmploi.first.id.toString();
                           listTitreEmploiLibelle.clear();
                           listTitreEmploi.forEach((element){
                             listTitreEmploiLibelle.add(element.libelle);
                           });
                         });

                         Navigator.pop(context);
                       }else{
                         Navigator.pop(context);
                       }
                     });
                   });


                 },
                 isExpanded: true,
                 items: listCategorieLibelle.map<DropdownMenuItem<String>>((String value) {
                   return DropdownMenuItem<String>(
                       value: value,
                       child: ItemDropmenu(value)

                   );
                 }).toList(),
               ),
             ),
           ],
         ),
       ),
     );
   }
*/

  Widget groupButtonsExperience(BuildContext context){
 final  List<String> listId=[];
 final  List<String> listLibelle=[];


    listExperience.forEach((element) {
      listId.add(element.id.toString());
      listLibelle.add(element.libelle.toString());
    });

    return Padding(padding: const EdgeInsets.all(2),
      child: GroupButton(
        crossGroupAlignment: CrossGroupAlignment.start,
        spacing: 2,
        isRadio: true,
        direction: Axis.horizontal,
        onSelected: (index, isSelected){
          annexp= listLibelle.elementAt(index).toString();

        },
        buttons: listLibelle,
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.orange,
        ),
        unselectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.grey[600],
        ),
        selectedColor: Colors.white,
        unselectedColor: Colors.grey[300],
        selectedBorderColor: Colors.orange,
        unselectedBorderColor: Colors.grey[500],
        borderRadius: BorderRadius.circular(10.0),
        selectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
        unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
      ),
    );

  }

  Widget groupButtonsHoraireTravail(BuildContext context){
    final  List<String> listId=[];
    final  List<String> listLibelle=[];

    listHoraireTravail.forEach((element) {
      listId.add(element.id.toString());
      listLibelle.add(element.libelle.toString());
    });

    return Padding(padding: const EdgeInsets.all(2),
      child: GroupButton(
        crossGroupAlignment: CrossGroupAlignment.start,
        spacing: 2,
        isRadio: true,
        direction: Axis.horizontal,
        onSelected: (index, isSelected){
         // horaireTravail= listLibelle.elementAt(index).toString();
          horaireTravail= listId.elementAt(index).toString();
        },
        buttons: listLibelle,
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.orange,
        ),
        unselectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.grey[600],
        ),
        selectedColor: Colors.white,
        unselectedColor: Colors.grey[300],
        selectedBorderColor: Colors.orange,
        unselectedBorderColor: Colors.grey[500],
        borderRadius: BorderRadius.circular(10.0),
        selectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
        unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
      ),
    );

  }

  Widget groupButtonsVedette(BuildContext context){
    final  List<String> listId=['','1', '0'];
    return Padding(padding: const EdgeInsets.all(4),
      child: GroupButton(
        crossGroupAlignment: CrossGroupAlignment.start,
        spacing: 2,
        isRadio: true,
        direction: Axis.horizontal,
        onSelected: (index, isSelected){
          vedette= listId.elementAt(index).toString();

        },
        buttons: [
          'Aucun choix',
          'Oui',
          'Non',
        ],
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.orange,
        ),
        unselectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.grey[600],
        ),
        selectedColor: Colors.white,
        unselectedColor: Colors.grey[300],
        selectedBorderColor: Colors.orange,
        unselectedBorderColor: Colors.grey[500],
        borderRadius: BorderRadius.circular(10.0),
        selectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
        unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
      ),
    );


  }
  Widget groupButtonsUrgente(BuildContext context){
    final  List<String> listId=['','1', '0'];
    return Padding(padding: const EdgeInsets.all(4),
      child: GroupButton(
        crossGroupAlignment: CrossGroupAlignment.start,
        spacing: 2,
        isRadio: true,
        direction: Axis.horizontal,
        onSelected: (index, isSelected){
          urgent= listId.elementAt(index).toString();
        },
        buttons: [
          'Aucun choix',
          'Oui',
          'Non',
        ],
        selectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.orange,
        ),
        unselectedTextStyle: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 10,
          color: Colors.grey[600],
        ),
        selectedColor: Colors.white,
        unselectedColor: Colors.grey[300],
        selectedBorderColor: Colors.orange,
        unselectedBorderColor: Colors.grey[500],
        borderRadius: BorderRadius.circular(10.0),
        selectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
        unselectedShadow: <BoxShadow>[BoxShadow(color: Colors.transparent)],
      ),
    );


  }

  /*SelectTempTravail(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Constante.kBlack.withOpacity(0.2)),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 20, top: 5),
        child: Row(
          children: [

            Expanded(
              child: DropdownButton<String>(
                value: tempTravail,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 0,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: ( newValue) {
                  newValue.toString().contains("Aucun choix") ? timeWork = "" :  timeWork= newValue.toString();
                  setState(() {
                    tempTravail = newValue!;
                  });
                },
                isExpanded: true,
                items: <String>[
                  'Aucun choix',
                  'Temps plein',
                  'Temps partiel',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: ItemDropmenu(value)
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }*/

  SelectDateAffichage(){
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Constante.kBlack.withOpacity(0.2)),
      ),
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 20, top: 5),
        child: Row(
          children: [

            Expanded(
              child: DropdownButton<String>(
                value: dateAffichage,
                icon: Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: const Icon(Icons.keyboard_arrow_down_outlined),
                ),
                iconSize: 24,
                elevation: 16,
                style: const TextStyle(color: Colors.deepPurple),
                underline: Container(
                  height: 0,
                  color: Colors.deepPurpleAccent,
                ),
                onChanged: ( newValue) {
                  if(newValue.toString().contains("24")){
                    hour="1";
                  }
                  if(newValue.toString().contains("7")){
                    hour="7";
                  }
                  if(newValue.toString().contains("14")){
                    hour="14";
                  }
                  if(newValue.toString().contains("Aucun")){
                    hour="";
                  }


                  setState(() {
                    dateAffichage = newValue!;
                  });
                },
                isExpanded: true,
                items: <String>[
                  'Aucun choix',
                  'Dernières 24 heures',
                  '7 derniers jours',
                  '14 derniers jours',
                ].map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: ItemDropmenu(value)
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

   Widget ItemDropmenu(String value) {
     return  Container(
       alignment: Alignment.centerLeft,
       child:
       Column(
         crossAxisAlignment: CrossAxisAlignment.start,
         children: [
           Padding(
             padding: const EdgeInsets.all(12.0),
             child: Text.rich(
               TextSpan(
                 style: GoogleFonts.questrial(
                   fontSize: 16.0,
                   color: Colors.black87,
                 ),
                 children: [
                   WidgetSpan(
                     child: Icon(Icons.arrow_right,color:Colors.black54, size: 15.0,),
                   ),
                   TextSpan(
                     text: value,
                   )
                 ],
               ),
             ),
           ),
         ],
       ),
     );

   }
}