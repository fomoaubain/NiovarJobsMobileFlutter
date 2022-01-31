import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Files.dart';

import 'package:niovarjobs/Global.dart' as session;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import 'drawer/drawer_header.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class ListDocument extends StatefulWidget {
  late String type;
  ListDocument(this.type);


  @override
  _ListDocument createState() => _ListDocument();
}

class _ListDocument extends State<ListDocument> {
  late String titre ="";
  late FToast fToast;
  var dio = Dio();

  ScrollController _scrollController = new ScrollController();
  late List<Files> objDocument=[],  initListDocument=[];
  late Future<List<Files>>  listDocumentRecent;
  var loading = false;

  Future<List<Files>> fetchItem(String type) async {
    List<Files> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+"RestCV/DocumentPostulant/"+session.id));
    if (response.statusCode == 200) {
      var data;
      if(type=="diplome") data = jsonDecode(response.body)['diplome'];
      if(type=="cv") data = jsonDecode(response.body)['cv'];
      if(type=="autre") data = jsonDecode(response.body)['autre'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Files.fromJson(element));
        });
      }
    }
    initListDocument=  listModel;

    return listModel.take(8).toList();
  }

  Future SupprimerDocument(String idDoc) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestCV/deleteCvDocument?id="+idDoc;
    var response = await dio.get(pathUrl);
    return response.data;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listDocumentRecent= fetchItem(widget.type);
    _scrollController.addListener(_onScroll);
    fToast = FToast();
    fToast.init(context);

    setState(() {
      if(widget.type=="diplome") titre= "Mes diplômes";
      if(widget.type=="cv") titre= "Mes CV";
      if(widget.type=="autre") titre= "Autres documents";
    });
  }

  _onScroll(){
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loading = true;
      });
      _fetchData();
    }

  }

  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      objDocument = initListDocument.take(objDocument.length+8).toList();
      loading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _scrollController.dispose();
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
          titre,
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body:  Container(
        child:FutureBuilder<List<Files>>(
          future: listDocumentRecent,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => ListDocument(widget.type)) )
              );
            }
            if(initListDocument.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune document disponible")
              );
            }
            if(snapshot.hasData) {
              if(objDocument.length==0){
                objDocument = snapshot.data ?? [];
              }else{
                objDocument = objDocument.toList();
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: loading ? objDocument.length + 1 : objDocument.length,
                  itemBuilder: (context,i){

                    if (objDocument.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Files nDataList = objDocument[i];
                    return Container(
                      child: Card(
                        elevation: 0.0,
                        margin: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child:makeListTile(nDataList, i),
                        ),
                      ),
                    );
                  }
              );
            }
            // By default, show a loading spinner.
            return Constante.ShimmerSimpleVertical(10);
          },
        ),
      ),


    );
  }


  ListTile makeListTile(Files item, int index) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Icon(Icons.file_present, size: 40,color: Colors.green,)
    ),
    title:Text(item.libelle,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
    subtitle:Text("Sauvegarder le : "+item.created,style: Constante.style6.copyWith(fontWeight: FontWeight.w400),),
    trailing: ShowPupopMenu(item, index),
  );

  Widget ShowPupopMenu( Files item, int index){
    return  PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Constante.TextwithIcon(Icons.save_alt, " Télécharger", Colors.black87, 15), value: 1),
        PopupMenuItem(child: Constante.TextwithIcon(Icons.dashboard_outlined, " supprimer", Colors.black87, 15), value: 2),
      ],
      onSelected: (value) async {
        if(value==1){
          _download(item);

        }
        if(value==2){
          removeDocument(item, index);
        }
      },
    );
  }

  void removeDocument(Files item, int index, ) async {
    Constante.showAlert(context, "Veuillez patientez", "Suppréssion en cour...", SizedBox(), 100);
    await SupprimerDocument(item.id.toString()).then((value){
      if(value['result_code'].toString()=="1"){
        Navigator.pop(context);
        setState(() {
          objDocument.removeAt(index);
        });
        Constante.showToastSuccess("Document supprimer avec succès ",fToast);

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

  Future _startDownload(String url, String savePath) async {
    ProgressDialog pd = ProgressDialog(context: context);
    try {
      var dio = new Dio();
      pd.show(max: 100, msg: 'Téléchargement en cour...');
      await dio.download(
        url,
        savePath,
        onReceiveProgress: (rec, total) {
          int progress = (((rec / total) * 100).toInt());
          pd.update(value: progress);
        },
      );
      Constante.showToastSuccess("Téléchargement terminé.",fToast);
      await new Future.delayed(new Duration(seconds: 2));
      OpenFile.open(savePath);
    } catch (e) {
      print(e);
      pd.close();
    }
  }

  Future<Directory?> _getDownloadDirectory() async {
    /*if (Platform.isAndroid) {
      return await DownloadsPathProvider.downloadsDirectory;
    }*/
    // in this example we are using only Android and iOS so I can assume
    // that you are not trying it for other platforms and the if statement
    // for iOS is unnecessary

    // iOS directory visible to user
    return await getApplicationDocumentsDirectory();
  }

  Future<bool> _requestPermissions() async {
    bool permissionGranted= false;
    if (await Permission.storage.request().isGranted) {
      setState(() {
        permissionGranted = true;
      });
    } else if (await Permission.storage.request().isPermanentlyDenied) {
      await openAppSettings();
    } else if (await Permission.storage.request().isDenied) {
      setState(() {
        permissionGranted = false;
      });
    }
    return permissionGranted;
  }

  Future<void> _download(Files item) async {
    var dir = "/storage/emulated/0/Download/";
    if(Platform.isIOS){
      var iosDir = await _getDownloadDirectory();
      dir= iosDir!.path;
    }
    final isPermissionStatusGranted = await _requestPermissions();
    if (isPermissionStatusGranted) {
      final savePath = path.join(dir, item.fileName);
      await _startDownload(Constante.serveurAdress+item.chemin, savePath);
    } else {
      Constante.showToastError("Echec du téléchargement",fToast);
    }
  }
}
