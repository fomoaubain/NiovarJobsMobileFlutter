import 'dart:async';
import 'dart:convert';

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
class Personnal_infos_Clt extends StatefulWidget {


  @override
  _Personnal_infos_Clt createState() => _Personnal_infos_Clt();
}

class _Personnal_infos_Clt extends State<Personnal_infos_Clt> {
  late FToast fToast;
  late Inscrire inscrire;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  bool _showLoading = true;

  String idCat="",  sexe="", annee="";
  late String  telephone="";
  bool validateNumber=false;
  late  final TextEditingController nom ;
  late final TextEditingController email ;
  late final TextEditingController description ;
  late final TextEditingController profession ;
  late final TextEditingController nomRepre ;
  late final TextEditingController prenomRepres ;
  late final TextEditingController numRepres ;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'CA';
  late PhoneNumber  number = PhoneNumber(isoCode: 'CA');

  final TextEditingController lieu = TextEditingController();

  String dropdownValue = 'One';
  String tempTravail = 'Aucun choix';
  String selectSexe = 'Aucun choix';
  String S3 = 'Aucun choix';
  late String categorie='Aucun choix';
  late String experience='Aucun choix';


  late Future<List<Types>> listCategorie;
  late List<Types> listCategorieData=[];

  late List<Experience> listExperience=[];

  late int idCategorie;
  List<String> listCategorieId=[];
  List<String> listSexe=['Aucun choix', 'Feminin', 'Masculin', 'Aucun',];
  List<String> listCategorieLibelle=["Aucun choix"];
  List<String> listExperienceLibelle=["Aucun choix"];



  Future EditInfos(var id, var idCat, var nom, var sexe, var email, var tel, var description, var nomRepre, var prenomRepre,  var profession, var telRepre) async {

    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Edit";
    FormData formData = new FormData.fromMap({
      'id': id,
      'categorie': idCat,
      'nom': nom,
      'sexe': sexe,
      'email_prof': email,
      'phone': tel,
      'description': description,
      'titreEmploi': profession,
      'nom_representant': nomRepre,
      'prenom_representant': prenomRepre,
      'titre_representant': profession,
      'tel_representant': telRepre,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;

  }

  Future _fetchData() async {
    final results = await Future.wait([
      http.get(Uri.parse(Constante.serveurAdress+"RestUser/getUser/"+session.id)),
      http.get(Uri.parse(Constante.serveurAdress+"RestJob/GetAllTypes")),
    ]);

    setState(() {
      final   responseInscrire= jsonDecode(results[0].body)['user'];
      if(responseInscrire!=null){
        inscrire = Inscrire.fromJson(responseInscrire);
        nom = TextEditingController(text: inscrire.nom);
        email = TextEditingController(text: inscrire.emailProf);
        description = TextEditingController(text: inscrire.description);
        profession = TextEditingController(text: inscrire.titreRepresentant);

        nomRepre = TextEditingController(text: inscrire.nomRepresentant);
        prenomRepres = TextEditingController(text: inscrire.prenomRepresentant);
        numRepres = TextEditingController(text: inscrire.telRepresentant);



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


      final responseCategorie = jsonDecode(results[1].body)['datas'];
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
          categorie= listModel.where((element) => element.id==int.parse(inscrire.categorie)).first.libelle;
          idCat=inscrire.categorie;
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
          " Profil de la compagnie",
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
                      "Choisir votre catégorie ou domaine d'activité de votre compagnie",
                      style: Constante.style4,
                    ),
                    SelectCategorie(),

                    SizedBox(height:size.height*0.02),
                    Text("Nom de la compagnie", style: Constante.style4,),
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
                    Text("Description de votre compagnie", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    Input1(),

                    SizedBox(height:size.height*0.03),
                    Text("Nom du représentant de la compagnie", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: nomRepre,
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
                    Text("Prénom du représentant de la compagnie", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: prenomRepres,
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

                    SizedBox(height:size.height*0.03),
                    Text("Titre du représentant de la compagnie", style: Constante.style4,),
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
                    Text("Numéro de télephone du représentant de la compagnie", style: Constante.style4,),
                    SizedBox(height:size.height*0.01),
                    TextFormField(
                      obscureText: false,
                      controller: numRepres,
                      keyboardType: TextInputType.phone,
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




  SelectCategorie(){

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
                      idCat="";
                      return;
                    }
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
          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await EditInfos(session.id,idCat, nom.text, sexe, email.text,telephone,description.text,nomRepre.text, prenomRepres.text,profession.text,numRepres.text).then((value){
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
        }else{
          Constante.showToastError("Veuillez remplir les champs obligatoire ", fToast);
        }
      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:
          Icon(Icons.check, color: Colors.green,)
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