

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/MesCandidatures.dart';
import 'package:niovarjobs/src/homePage.dart';
import 'package:niovarjobs/widget/filter_pressed-Button.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;

class PostulerDirectement extends StatefulWidget {

  late Postuler postuler ;
  PostulerDirectement(this.postuler);

  @override
  _PostulerDirectement createState() => _PostulerDirectement(postuler);
}

class _PostulerDirectement extends State<PostulerDirectement> {

  late Postuler postuler ;

  _PostulerDirectement(this.postuler);

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

  Future postulerDirectement(String idJob, String idUser, String path, String fileName, String To  ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestJob/postulerDirectement";
    FormData formData = new FormData.fromMap({
      "idJob": idJob,
      "idUser": idUser,
      "To": To,
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
          "Postuler directement",
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
                "Envoyer votre candidature",
                style: GoogleFonts.questrial(
                  fontSize: 20.0,
                  color: Constante.kBlack,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 20,),

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
              SizedBox(height: 20,),
              Text(
                "Note informative : \n "
                    "Cette compagnie n'existe pas sur notre plateforme. Cette offre est publiée en dehors de NiovarJobs.",
                style: GoogleFonts.questrial(
                  fontSize: 12.0,
                  color: Constante.kBlack,
                  fontWeight: FontWeight.w200,
                ),
              ),
              SizedBox(height: 70,),

              customButton("Soumettre ma candidature"),


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
            if(_fileName.isEmpty ){
              _showToast("Veuillez selectionner votre CV");
              return;
            }

            Constante.showAlert(context, "Veuillez patientez", "Envoie du CV en cour...", SizedBox(), 100);
            await postulerDirectement(postuler.job.id.toString(), session.id, _path, _fileName, postuler.inscrire.email).then((value){
              if(value['result_code'].toString()=="1"){
                Navigator.pop(context);
                Constante.showAlert(context, "Note d'information", "Votre candidature à été envoyer avec succès. ",
                    SizedBox(
                      child: RaisedButton(
                        padding: EdgeInsets.all(10),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pop(context);
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => MesCandidatures()));
                        },
                        child: Text(
                          "Voir mes candidatures",
                          style: TextStyle(color: Colors.white),
                        ),
                        color:Colors.orange,
                      ),
                    ),
                    170);
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



          },
            child: Container(
              height: 55,
              width: double.infinity,
              child: Center(
                child: Text(text,style: Constante.kTitleStyle.copyWith(
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