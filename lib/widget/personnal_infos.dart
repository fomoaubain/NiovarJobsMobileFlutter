import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:multi_select_flutter/bottom_sheet/multi_select_bottom_sheet_field.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';
import 'package:multi_select_flutter/util/multi_select_list_type.dart';
import 'package:niovarjobs/model/Categorie.dart';
import 'package:niovarjobs/model/Experience.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Type.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart'  as session;
class Personnal_infos extends StatefulWidget {


  @override
  _Personnal_infos createState() => _Personnal_infos();
}

class _Personnal_infos extends State<Personnal_infos> {
  late FToast fToast;
  late Inscrire inscrire;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _showLoading = true ,  isLoading = false;

  String listIdCatSelected="", idEmploi="", sexe="", annee="";
  late String  telephone="";
  bool validateNumber=false;
  late  final TextEditingController nom ;
  late final TextEditingController email ;
  late final TextEditingController description ;
  late final TextEditingController profession ;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CA';
  late PhoneNumber  number = PhoneNumber(isoCode: 'CA');

  final TextEditingController lieu = TextEditingController();

  String dropdownValue = 'One';
  String tempTravail = 'Aucun choix';
  String selectSexe = 'Aucun choix';
  String titreEmploi="Aucun choix";
  String S3 = 'Aucun choix';
  late String categorie='Aucun choix';
  late String experience='Aucun choix';


  late Future<List<Types>> listCategorie;
  late List<Types> listCategorieData=[];
  late List<Categorie> listTitreEmploi=[];
  late List<Experience> listExperience=[];

  late int idCategorie;
  List<String> listCategorieId=[];
  List<String> listSexe=['Aucun choix', 'Feminin', 'Masculin', 'Aucun',];
  List<String> listCategorieLibelle=["Aucun choix"];
  List<String> listExperienceLibelle=["Aucun choix"];
  List<String> listTitreEmploiLibelle=["Aucun choix"];
  List<String> listTitreEmploiId=[];

  late List<Types> _selectedCategorie = [];

  List<Types> _selectedCategorieInitValue = [];


  Future FindTitreEmploi(int id ) async{
    final String pathUrl = Constante.serveurAdress+"RestJob/GetAllTitreEmploi/"+id.toString();
    final response = await http.get(Uri.parse(pathUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      return data;
    }else{
      return null;
    }
  }

  Future EditInfos(var id, var listIdCatSelected, var idEmploi, var nom, var sexe, var email, var tel, var description,  var profession, var anneExp) async {

    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Edit";
    FormData formData = new FormData.fromMap({
      'id': id,
      'nom': nom,
      'categorie': listIdCatSelected,
      'domaine': idEmploi,
      'sexe': sexe,
      'email_prof': email,
      'phone': tel,
      'description': description,
      'titreEmploi': profession,
      'anneeExperience': anneExp,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }

  Future _fetchData() async {
    final results = await Future.wait([
      http.get(Uri.parse(Constante.serveurAdress+"RestUser/getUser/"+session.id)),
     http.get(Uri.parse(Constante.serveurAdress+"RestJob/GetAllAnneeExp")),
    http.get(Uri.parse(Constante.serveurAdress+"RestJob/GetAllTypes")),
    ]);

    setState(() {
    final   responseInscrire= jsonDecode(results[0].body)['user'];
    if(responseInscrire!=null){
      inscrire = Inscrire.fromJson(responseInscrire);
      nom = TextEditingController(text: inscrire.nom);
      email = TextEditingController(text: inscrire.emailProf);
      description = TextEditingController(text: inscrire.description);
      profession = TextEditingController(text: inscrire.titreEmploi);

      if(inscrire.domaine.isNotEmpty){
        titreEmploi= inscrire.libelleTitreEmploi;
        listTitreEmploiLibelle.clear();
        listTitreEmploiLibelle.add(inscrire.libelleTitreEmploi);
        idEmploi=inscrire.domaine;
      }
      if(inscrire.sexe.isNotEmpty){
        if(inscrire.sexe.toString().contains("F")){
          selectSexe="Feminin";
        }
        if(inscrire.sexe.toString().contains("M")){
          selectSexe="Masculin";
        }
        if(inscrire.sexe.toString().contains("FM")){
          selectSexe="Aucun";
        }
        sexe=inscrire.sexe;
      }
      if(!inscrire.phone.isEmpty){
        getPhoneNumber(inscrire.phone);
      }
    }


    final responseExperience = jsonDecode(results[1].body)['datas'];
    if(responseExperience!=null){
      List<Experience> listModelExperience = [];
      responseExperience.forEach((element) {
        listModelExperience.add(Experience.fromJson(element));
      });
      listExperience = listModelExperience.toList();
      listModelExperience.forEach((element) {
        listExperienceLibelle.add(element.libelle);
      });
      if(inscrire.anneeExperience.isNotEmpty){
        experience= listModelExperience.where((element) => element.id==int.parse(inscrire.anneeExperience)).first.libelle;
        annee=inscrire.anneeExperience;
      }
    }

    final responseCategorie = jsonDecode(results[2].body)['datas'];
    if(responseCategorie!=null){
      List<Types> listModel = [];
      responseCategorie.forEach((element) {
        listModel.add(Types.fromJson(element));
      });
      listModel.forEach((element) {
        listCategorieLibelle.add(element.libelle);
      });
      listCategorieData=listModel.toList();

      if(inscrire.categorie.isNotEmpty){
        inscrire.categorie.toString().split(",").forEach((item) {
          _selectedCategorieInitValue.add(listModel.where((element) => element.id==int.parse(item)).first);
        });
        listIdCatSelected=inscrire.categorie;
      }
    }

    _showLoading = false;

    });
  }


  @override
  void initState() {
    super.initState();

    _fetchData();
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
          "Informations sur mon profil",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          ShowCheckButton(),
        ],
      ),

      body:  Container(
        margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
        child: SingleChildScrollView(
          child:   Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (_showLoading)
                    Center(child: Constante.circularLoader()),

                  if (!_showLoading) ...[
                    Text(
                      "Choisir vos catégories ou domaine d'activité",
                      style: Constante.style4,
                    ),
                    MultiSelectCategorie(),
                    SizedBox(height:size.height*0.02),
                    Text("Année d'experience", style: Constante.style4,),
                    selectedExperience(),
                    SizedBox(height:size.height*0.02),
                    Text("Nom et prenom", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: nom,
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
                    Text("Sexe", style: Constante.style4,),
                    selectedSexe(),
                    SizedBox(height:size.height*0.02),
                    Text("Email professionnelle", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: email,
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
                        if(!RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(value)){
                          return "Adresse courriel incorrect";
                        }
                        if(value.length>50){
                          return "maximum 50 caracteres";
                        }
                        return null;
                      },
                    ),
                    SizedBox(height:size.height*0.03),
                    Text("Numéro de téléphone", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
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
                        hintText: 'Numéro de téléphone',
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
                          return "Numéro de telephone incorrect";
                        }
                        return null;
                      },

                    ),
                    SizedBox(height:size.height*0.04),
                    Text("Description de votre personnalité", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    Input1(),
                    SizedBox(height:size.height*0.03),
                    Text("Proféssion", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: profession,
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
                  ],
                ],
              )
          ),

        ),
      ),
    );

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
  }*/
  MultiSelectCategorie(){
    return MultiSelectBottomSheetField(
//  items: listCategorieData.map((e) => MultiSelectItem(e, e.libelle)).toList(),
      items: listCategorieData.map((e) => MultiSelectItem<Types>(e, e.libelle))
          .toList(),
      initialValue: _selectedCategorieInitValue.toList(),
      validator: (values) {
        if (values == null || values.isEmpty) {
          return "Veuillez choisir au moins une catégorie";
        }

        if (values.length>4) {
          return "Impossible de selectionnez plus de 4 catégories";
        }
        return null;
      },
      listType: MultiSelectListType.CHIP,
      cancelText: Text("Annuler"),
      confirmText: Text("Terminer"),
      title:Text("Cliquer ici pour selectionner"),
      searchable:true,
      searchHint: "Selectionner",
      onConfirm: (values) {
        setState(() {
          _selectedCategorie= values.cast<Types>().toList();
        });

      },
    );
  }

  selectedSexe(){
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
                value: selectSexe,
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
                  if(newValue.toString().contains("Feminin")){
                    sexe="F";
                  }
                  if(newValue.toString().contains("Masculin")){
                    sexe="M";
                  }
                  if(newValue.toString().contains("Aucun")){
                    sexe="FM";
                  }
                  if(newValue.toString().contains("Aucun choix")){
                    sexe="";
                  }


                  setState(() {
                    selectSexe = newValue!;
                  });
                },
                isExpanded: true,
                items: listSexe.map<DropdownMenuItem<String>>((String value) {
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

  selectedExperience(){
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
                value: experience,
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
                  listExperience.forEach((element){
                    if(newValue== element.libelle){
                      newValue = element.libelle;
                      annee=element.id.toString();
                    }
                  });
                  setState(() {
                    experience = newValue!;
                    if(experience=="Aucun choix"){
                      annee="";
                      return;
                    }
                  });

                },
                isExpanded: true,
                items: listExperienceLibelle.map<DropdownMenuItem<String>>((String value) {
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

  Widget Input1(){
    return TextFormField(
      cursorColor: Colors.black,
      maxLines: 4,
      controller: description,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: "Description de votre personnalité",
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

  Widget ShowCheckButton() {
    return  InkWell(
      onTap: () async{
        if(formKey.currentState!.validate()){
          setState(() {isLoading = true;});
          listIdCatSelected="";
          _selectedCategorie.forEach((element) {
            listIdCatSelected+=element.id.toString()+",";
          });
          listIdCatSelected = listIdCatSelected.substring(0, listIdCatSelected.length - 1);

          await EditInfos(session.id,listIdCatSelected, idEmploi, nom.text, sexe, email.text,telephone,description.text,profession.text,annee).then((value){
            setState(() {isLoading = false;});
            if(value['result_code'].toString().contains("1")){

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
  void getPhoneNumber(String phoneNumber) async {
    PhoneNumber number =
    await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumber);

    setState(() {
      this.number = number;
    });
  }

}