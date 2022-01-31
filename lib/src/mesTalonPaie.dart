import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
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

class MesTalonPaie extends StatefulWidget {

  @override
  _MesTalonPaie createState() => _MesTalonPaie();
}

class _MesTalonPaie extends State<MesTalonPaie> {

  ScrollController _scrollController = new ScrollController();
  late List<Files> objTalonPaie=[],  initListTalonPaie=[];
  late Future<List<Files>>  listTalonPaie;
  var loading = false;
  late FToast fToast;

  Future<List<Files>> fetchItem(String urlApi) async {
    List<Files> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Files.fromJson(element));
        });
      }
    }
    initListTalonPaie=  listModel;
    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listTalonPaie= this.fetchItem('RestUser/MesTalonPaie?id='+session.id);
    _scrollController.addListener(_onScroll);
    fToast = FToast();
    fToast.init(context);
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
      objTalonPaie = initListTalonPaie.take(objTalonPaie.length+8).toList();
      loading = false;
    });
  }

  Future marqueLu(String idFile) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/marqueLu?id="+idFile;
    var response = await dio.get(pathUrl);
    return response.data;
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
          "Mes talons de paie",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body:  Container(
        child:FutureBuilder<List<Files>>(
          future: listTalonPaie,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => MesTalonPaie()))
              );
            }
            if(initListTalonPaie.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucun talon de paie trouvé")
              );
            }
            if(snapshot.hasData) {
              if(objTalonPaie.length==0){
                objTalonPaie = snapshot.data ?? [];
              }else{
                objTalonPaie = objTalonPaie.toList();
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: loading ? objTalonPaie.length + 1 : objTalonPaie.length,
                  itemBuilder: (context,i){
                    if (objTalonPaie.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Files nDataList = objTalonPaie[i];
                    return BuildTableCard(context, nDataList, i);
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

  Widget BuildTableCard(BuildContext context, Files item, int index) {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child:Text(item.libelle.toString(), style:  GoogleFonts.questrial(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w400,
                    color: Color(0xF8F6894D),
                    wordSpacing: 1.5,
                  )),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Constante.kOrange,
                      ),
                      child: IconButton(
                          onPressed: () async {
                            _download(item);
                            marqueLu(item.id.toString());
                            await marqueLu(item.id.toString()).then((value){
                              if(value['result_code'].toString()=="1"){
                                Files newItem  = objTalonPaie.firstWhere((item) => item.id == item.id);
                               newItem.etat=0;
                                setState(() {
                                  objTalonPaie.removeAt(index);
                                  objTalonPaie.insert(index, newItem);
                                });
                              }
                            }
                            );
                          },
                          icon: Icon(
                            Icons.save_alt,
                            color: Colors.white,
                            size: 17,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),

                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Récus le :',
                        style: Constante.style4,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.created,
                    ),
                  ],
                ),
              ],
            ),

            SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                        'Statut :',
                        style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.w900)
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    setStatus(item),
                  ],
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
    );
  }

  Widget setStatus(Files item){
    String msg=""; Color colors=Colors.transparent;
    if(item.etat.toString()=="0"){
      msg="Vu"; colors= Colors.blue ;
    }else if(item.etat.toString()=="1"){
      msg="nouveau"; colors= Colors.green;
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          alignment: Alignment.center,
          margin: EdgeInsets.only(right: 10.0),
          padding:
          EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: colors,
          ),
          child: Text(
            msg,
            style: Constante.kSubtitleStyle.copyWith(
              color: Colors.white,
              fontSize: 10.0,
            ),
          ),
        ),
      ],
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
   /* if (Platform.isAndroid) {
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