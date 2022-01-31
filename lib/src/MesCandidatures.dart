import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Postuler.dart';

import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart' as session;
import 'package:niovarjobs/src/DetailsJob.dart';

class MesCandidatures extends StatefulWidget {

  @override
  _MesCandidatures createState() => _MesCandidatures();
}

class _MesCandidatures extends State<MesCandidatures> {
  ScrollController _scrollController = new ScrollController();
  late List<Postuler> objCandidatures=[],  initListCandidatures=[];
  late Future<List<Postuler>>  listCandidatures;
  var loading = false;
  late FToast fToast;

  Future<List<Postuler>> fetchItem(String urlApi) async {
    List<Postuler> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Postuler.fromJson(element));
        });
      }
    }
    initListCandidatures=  listModel;
    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCandidatures= this.fetchItem('RestJob/MesCandidatures?id='+session.id);
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
      objCandidatures = initListCandidatures.take(objCandidatures.length+8).toList();
      loading = false;
    });
  }

  Future retirerCandidature(String idPostuler) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestJob/DeletePostuler?idPostuler="+idPostuler;
    var response = await dio.get(pathUrl);
    return response.data;
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
          "Mes candidatures",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        child:FutureBuilder<List<Postuler>>(
          future: listCandidatures,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => MesCandidatures()))
              );
            }
            if(initListCandidatures.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune candidature trouvée")
              );
            }
            if(snapshot.hasData) {
              if(objCandidatures.length==0){
                objCandidatures = snapshot.data ?? [];
              }else{
                objCandidatures = objCandidatures.toList();
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: loading ? objCandidatures.length + 1 : objCandidatures.length,
                  itemBuilder: (context,i){

                    if (objCandidatures.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Postuler nDataList = objCandidatures[i];
                    return BuildTableCard(context, nDataList, i);
                  }
              );
            }
            // By default, show a loading spinner.
            return Constante.circularLoader();
          },
        ),
      ),

    );
  }



  Widget BuildTableCard(BuildContext context, Postuler item, int index) {
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
                  child:Text(item.job.titre, style:  GoogleFonts.questrial(
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
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => DetailsJob( idJob: item.job.id,forVisit: true,)));
                          },
                          icon: Icon(
                            Icons.remove_red_eye,
                            color: Colors.white,
                            size: 17,
                          )),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Constante.kOrange),
                      child: IconButton(
                          onPressed: () {
                            removeCandidature(item,index);
                          },
                          icon: Icon(
                            Icons.delete,
                            color: Colors.white,
                            size: 17,
                          )),
                    ),
                  ],
                ),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.location_pin,
                  size: 17,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Lieu :', style: Constante.style4),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  item.job.pays+", "+item.job.province+", "+item.job.ville,
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
                        'Publiée le :',
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
              height: 5,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.date_range,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Date de fin :',
                        style: Constante.style4,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.job.dateFinOffre,
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



  Widget setStatus(Postuler item){
    String msg=""; Color colors=Colors.orange;
    if(item.etatCandidat=="0"){
    msg="en attente d'évaluation"; colors= Colors.orange ;
    }else if(item.etatCandidat=="1"){
      msg="en évaluation"; colors= Colors.orange;
    }else if(item.etatCandidat=="2"){
      if(item.etatClient=="2" && item.job.immediatLabel=="true"){
        msg="en cour de traitement..."; colors= Colors.blue.shade300 ;
      }else{
        msg="candidature accepté"; colors= Colors.green;
      }
    }else if(item.etatCandidat=="3"){
      msg="candidature refusé"; colors= Colors.redAccent;
    }else if(item.etatCandidat=="4"){
      msg="en entrevus"; colors= Colors.blue ;
    }else if(item.etatCandidat=="5"){
      msg="contrat terminé"; colors= Colors.green ;
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

  void removeCandidature(Postuler postuler, int index, ) async {
    Constante.AlertLoadingWithMessage(context);
    await retirerCandidature(postuler.id.toString()).then((value){
      if(value['result_code'].toString()=="1"){
        Navigator.pop(context);
        setState(() {
          objCandidatures.removeAt(index);
        });
        Constante.showToastSuccess("Candidature rétirer avec succès ",fToast);
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
    ).catchError((error){
      setState(() {
        Constante.AlertInternetNotFound(context);
      });
    });

  }

}
