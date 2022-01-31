import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
//import 'package:downloads_path_provider_28/downloads_path_provider_28.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Affectations.dart';
import 'package:niovarjobs/model/ContratTravail.dart';
import 'package:niovarjobs/model/Files.dart';

import 'package:niovarjobs/Global.dart' as session;
import 'package:niovarjobs/src/ContratTravailCdt.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:permission_handler/permission_handler.dart';

import 'drawer/drawer_header.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart' as path;

class MesContratTravail extends StatefulWidget {

  @override
    _MesContratTravail createState() => _MesContratTravail();
}

class _MesContratTravail extends State<MesContratTravail> {

  ScrollController _scrollController = new ScrollController();
  late List<ContratTravail> objContratTravail=[],  initListContratTravail=[];
  late Future<List<ContratTravail>>  listContratTravail;
  var loading = false;
  late FToast fToast;
  bool refresh = false;

  Future<List<ContratTravail>> fetchItem(String urlApi) async {
    List<ContratTravail> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(ContratTravail.fromJson(element));
        });
      }
    }
    initListContratTravail=  listModel;
    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listContratTravail= this.fetchItem('RestUser/MesContratTravail?id='+session.id);
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
      objContratTravail = initListContratTravail.take(objContratTravail.length+8).toList();
      loading = false;
    });
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
          "Mes contrats de travail",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body:  Container(
        child:FutureBuilder<List<ContratTravail>>(
          future: listContratTravail,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => MesContratTravail()))
              );
            }
            if(initListContratTravail.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune contrat de travail trouvé")
              );
            }
            if(snapshot.hasData) {
              if(objContratTravail.length==0){
                objContratTravail = snapshot.data ?? [];
              }else{
                objContratTravail = objContratTravail.toList();
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: loading ? objContratTravail.length + 1 : objContratTravail.length,
                  itemBuilder: (context,i){
                    if (objContratTravail.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    ContratTravail nDataList = objContratTravail[i];
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

  Widget BuildTableCard(BuildContext context, ContratTravail item, int index) {
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
                  child:Text("Contrat de travail", style:  GoogleFonts.questrial(
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
                            goToSecondScreen(context, MaterialPageRoute(builder: (context) => ContratTravailCdt(item)));
                          },
                          icon: Icon(
                            Icons.remove_red_eye_sharp,
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

  Widget setStatus(ContratTravail item){
    String msg=""; Color colors=Colors.transparent;
    if(item.etatSignCdt.toString()=="2"){
      msg="Signé"; colors= Colors.green ;
    }else if(item.etatSignCdt.toString()=="1"){
      msg="En attente de signature"; colors= Colors.orange;
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




}