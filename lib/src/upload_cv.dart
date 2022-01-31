

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/src/homePage.dart';
import 'package:niovarjobs/widget/filter_pressed-Button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class UploadCv extends StatefulWidget {

  @override
  _UploadCv createState() => _UploadCv();
}

class _UploadCv extends State<UploadCv> {
  late FToast fToast;

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  TextEditingController t1Controller = TextEditingController();

  late String _fileName="";

  int indicator = 0;

  late String _path;
  late Map<String, String> _paths;
  late String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  late FileType _pickingType;
  late bool imageCheck = false;
  bool isLoading = false;

  Future uploadCv(String pseudo, String path, String fileName  ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/importerCV";
    FormData formData = new FormData.fromMap({
      "login": pseudo,
      "file": await MultipartFile.fromFile(path, filename: fileName),
    });
    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
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
          "Importer document",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body:Container( margin: EdgeInsets.symmetric(horizontal: 20,vertical: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Envoyer votre CV',
                style: Constante.style4.copyWith(fontSize: 30),
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Text('Nom, prénom ou Pseudo',style: Constante.style4,),
              ),
              TextFormField(
                obscureText: false,
                controller: t1Controller,
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

              customButton("Importer"),


            ],
          ),
        ),
      ),

    );

  }

  Widget customButton(text){
    return InkWell(
      child: Card(
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          color: Colors.orange,
          child: InkWell( onTap: () async {
            if(t1Controller.text.isEmpty ){
              _showToast("Veuillez saisir votre pseudo ou votre nom");
              return;
            }
            if(t1Controller.text.length>50 ){
              _showToast("Nombre de caractères depasser");
              return;
            }

            if(_fileName.isEmpty ){
              _showToast("Veuillez selectionner votre CV");
              return;
            }
            setState(() {
              isLoading=true;
            });
            await uploadCv(t1Controller.text, _path, _fileName).then((value){
              setState(() {
                isLoading=false;
              });
              if(value['result_code'].toString()=="1"){
                Constante.showAlert(context, "Note d'information", "Votre CV à été importer avec succès et seras analysé par l'équipe NiovarJobs ",
                    SizedBox(
                      child: RaisedButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => homePage(title: "",)
                              ),
                              ModalRoute.withName("/Home")
                          );
                        },
                        child: Text(
                          "Cliquer ici pour continuer",
                          style: TextStyle(color: Colors.white),
                        ),
                        color:Colors.orange,
                      ),
                    ),
                    170);
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
          },
            child: Container(
              height: 55,
              width: double.infinity,
              child: Center(
                child: (isLoading)
                    ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 1.5,
                    ))
                    :Text(text,style: Constante.kTitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w400
                ),),
              ),
            ),
            borderRadius: BorderRadius.circular(10),
          )
      ),
    );

  }


  _showToast(String msg) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black87,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 12),),
        ],
      ),
    );

    fToast.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

  }


}