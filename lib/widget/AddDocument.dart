import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;

class AddDocument extends StatefulWidget {
  @override
  _AddDocument createState() => _AddDocument();
}

class _AddDocument extends State<AddDocument> {

  late FToast fToast;
  late String _fileName="";
  String Document='Aucun choix';
  late String typeDocument ="";

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nomfichier = TextEditingController();

  TextEditingController dateFin = TextEditingController();
  late String _path;
  late Map<String, String> _paths;
  late String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  late FileType _pickingType;
  late bool imageCheck = false;

  Future uploadDocument(String id, String type, String nomfichier, String path, String fileName  ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestCV/CvDocument";
    FormData formData = new FormData.fromMap({
      "Ins_id": id,
      "type": type,
      "libelle": nomfichier,
      "files": await MultipartFile.fromFile(path, filename: fileName),
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
          "Ajouter un document",
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
            child:  Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Type de document',style: Constante.style4,),
                ),
                SelectTypeDocument(),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Nom du fichier',style: Constante.style4,),
                ),
                TextFormField(
                  controller: nomfichier,
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
                SizedBox(height: 30,),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  child: InkWell( onTap: (){
                    _openFileExplorer();
                  },
                    child: Container(
                      height: 160,
                      decoration: BoxDecoration(
                        border: Border.all(color: Constante.kBlack.withOpacity(0.2),),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(top: 12,bottom: 12,left: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Center(
                                child:Icon(Icons.folder,size: 60,color: Constante.kBlack.withOpacity(0.2),)),
                            SizedBox(
                              width: 20,
                            ),

                            imageCheck ?
                            Constante.TextwithIcon(Icons.check_circle_outline, _fileName, Colors.green, 12) :
                            Text(
                              "Selectionner votre Cv" ,
                              style: Constante.style6,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 70,),
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
        if(typeDocument.isEmpty){
          Constante.showToastError("Veuillez selectionner le type de votre document", fToast);
          return;
        }
        if(_fileName.isEmpty){
          Constante.showToastError("Veuillez selectionner votre document", fToast);
          return;
        }
        if(formKey.currentState!.validate()){
          print(typeDocument.toString());
          print(_path);
          print(nomfichier.text);

          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde du document en cour...", SizedBox(), 100);
          await uploadDocument(session.id, typeDocument, nomfichier.text, _path, _fileName).then((value) async {
            if(value['result_code'].toString()=="1"){
              Navigator.pop(context);
              Constante.showToastSuccess("Sauvegarde éffectué avec succès ",fToast);
              await new Future.delayed(new Duration(seconds: 2));
              Navigator.pop(context);
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

      },
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10),
          child:
          Icon(Icons.check, color: Colors.green,)
      ),

    );

  }

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['txt', 'pdf', 'doc','docx', 'jpg','png', 'jpeg'],);

    if(result != null) {
      PlatformFile file = result.files.first;
      setState(() {
        imageCheck=true;
        _path= file.path.toString();
        _fileName= file.name;
      });

    } else {
      // User canceled the picker
    }
  }

  SelectTypeDocument(){
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
                value: Document,
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
                  if(newValue.toString()=='Diplôme'){
                    typeDocument="diplome";
                  }
                  if(newValue.toString()=='CV'){
                    typeDocument="cv";
                  }
                  if(newValue.toString()=='Autre document'){
                    typeDocument="autre";
                  }
                  if(newValue.toString()=='Aucun choix'){
                    typeDocument="";
                  }
                  setState(() {
                    Document = newValue!;
                  });
                },
                isExpanded: true,
                items: <String>[
                  'Aucun choix',
                  'Diplôme',
                  'CV',
                  'Autre document',
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