import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/Global.dart'  as session;
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/src/EditPwd.dart';
import 'package:niovarjobs/widget/Personnal_infos_Clt.dart';
import 'package:niovarjobs/widget/localisation_infos.dart';
import 'package:niovarjobs/widget/personnal_infos.dart';
import 'package:niovarjobs/widget/social_infos.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'homePage.dart';

class Profil extends StatefulWidget {

  @override
  _Profil createState() => _Profil();
}

class _Profil extends State<Profil> {
  late String _fileName;
  late String _path;
  late Map<String, String> _paths;
  late String _extension;
  bool _loadingPath = false;
  bool _multiPick = false;
  bool _hasValidMime = false;
  late FileType _pickingType;
  late bool imageCheck = false;

  void _openFileExplorer() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom,
      allowedExtensions: ['jpg','png', 'jpeg'],);

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

  Future EditProfil(String id, String path, String fileName  ) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/EditProfil";
    FormData formData = new FormData.fromMap({
      "id": id,
      "file": await MultipartFile.fromFile(path, filename: fileName),
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );

    return response.data;
  }


  @override
  void initState() {
    super.initState();
    setState(() {
      _fileName= session.profil;
    });
  }

  @override
  Widget build(BuildContext context) {
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
          "Mon profil",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
        actions: <Widget>[
          imageCheck ? ShowCheckButton()  : SizedBox(width: 0.0) ,

        ],
      ),

      body: getBody(context),
    );

  }

  getBody(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      child: Stack(
        children: [
          ClipPath(
            clipper: OvalBottomBorderClipper(),
            child: Container(
              height: size.height * 0.5,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(50),
                  bottomLeft: Radius.circular(50),
                ),
                color: Colors.orange,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 30,right: 20,left: 20,),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      _openFileExplorer();
                    },
                    child: Container(
                      height: 150,
                      width: 150,
                      child: Padding(
                        padding: EdgeInsets.only(top: 0.0),
                        child: new Stack(fit: StackFit.loose, children: <Widget>[
                          new Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              new Container(
                                  width: 140.0,
                                  height: 140.0,
                                  child: imageCheck ? assetimage(_path):networkimage(Constante.serveurAdress+_fileName),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Constante.kBlack.withOpacity(0.2),
                                      spreadRadius: 2,
                                      blurRadius: 4,
                                      offset: Offset(0, 3), // changes position of shadow
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Padding(
                              padding: EdgeInsets.only(top: 90.0, right: 100.0),
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  new CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 25.0,
                                    child: new Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                    ),
                                  )
                                ],
                              )),
                        ]),
                      ),
                    ),
                  ),
                  SizedBox(height: size.height*0.03,),
                  Text(
                    session.email,
                    style: Constante.kPageTitleStyle.copyWith(fontSize: 18,color: Colors.white, fontWeight: FontWeight.w400),
                  ),
                  SizedBox(height: size.height*0.03,),
                  Row(
                    children: [
                      Profilecards(1,session.type=="client" ? "Profil de la \n   compagnie" :"Informations  \n sur mon profil", Icons.perm_contact_calendar_outlined),
                      Profilecards(2,session.type=="client" ?'Adresse de\n  la compagnie': "Mon adresse", Icons.location_on),
                    ],
                  ),
                  SizedBox(height: size.height*0.03,),
                  Row(
                    children: [
                      Profilecards(3,session.type=="client" ? 'Réseaux sociaux \n  de la compagnie': "Réseaux \n sociaux", Icons.alternate_email),
                      Profilecards(4,'Changer le \n mot de passe', Icons.edit),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Profilecards(int id , String text,IconData iconData) {
    return Expanded(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        elevation: 8,
        child: InkWell( onTap: (){
          if(id==4){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => EditPwd()));
          }
          if(id==1){
            if(session.type=="client"){
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Personnal_infos_Clt()));
            }else{
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Personnal_infos()));
            }

          }
          if(id==3){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Social_infos()));
          }
          if(id==2){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Localisation_infos()));
          }
        },
          child: Container(
            height: 150,
            width: double.infinity,
            child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Icon(iconData, color: Colors.green.shade300,size: 30,),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Text(text,style: GoogleFonts.questrial(
                        fontSize: 16.0,
                        color: Constante.kBlack,
                        fontWeight: FontWeight.w400,
                      ),),
                    )
                  ],
                ),

               ),
          ),
        ),
      ),
    );
  }

  networkimage(String src) {
    return CircleAvatar(
      radius: 30.0,
      backgroundImage:
      NetworkImage(src),
      backgroundColor: Colors.transparent,
    );
  }

  assetimage(String src) {
    return CircleAvatar(
      radius: 30.0,
      backgroundImage:FileImage(File(_path)),
      backgroundColor: Colors.transparent,
    );
  }

 Widget ShowCheckButton() {
     return  InkWell(
      onTap: () async{

        Constante.showAlert(context, "Veuillez patientez", "Modification du profil en cour...", SizedBox(), 100);
        await EditProfil(session.id, _path, _fileName).then((value) async {
          if(value['result_code'].toString()=="1"){
            Navigator.pop(context);
            Constante.showAlert(context, "Note d'information", "Profil modifié avec succès", SizedBox(), 100);
            await new Future.delayed(new Duration(seconds: 2));
            Inscrire inscrire = Inscrire.fromJson(value['user']);
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            if(inscrire!=null){
              prefs.setString('profil', inscrire.profilName);
            }
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                    builder: (context) => homePage(title: "",)
                ),
                ModalRoute.withName("/Home")
            );

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

        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child:
        Icon(Icons.check, color: Colors.green,)
      ),

    );
  }
}