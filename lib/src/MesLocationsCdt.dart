import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Location.dart';
import 'package:niovarjobs/model/Postuler.dart';

import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart' as session;
import 'package:niovarjobs/src/DetailsJob.dart';

class MesLocationsCdt extends StatefulWidget {

  @override
  _MesLocationsCdt createState() => _MesLocationsCdt();
}

class _MesLocationsCdt extends State<MesLocationsCdt> {
  ScrollController _scrollController = new ScrollController();
  late List<Location> objLocation=[],  initListLocation=[];
  late Future<List<Location>>  listLocation;
  var loading = false;
  late FToast fToast;

  Future<List<Location>> fetchItem(String urlApi) async {
    List<Location> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Location.fromJson(element));
        });
      }
    }
    initListLocation=  listModel;

    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listLocation= this.fetchItem('RestLouer/mesLocationsCandidat?id='+session.id);
    _scrollController.addListener(_onScroll);
    fToast = FToast();
    fToast.init(context);
    print(session.id);
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
      objLocation = initListLocation.take(objLocation.length+8).toList();
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
          "Mes demandes de locations ",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        child:FutureBuilder<List<Location>>(
          future: listLocation,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.circularLoader();
            }
            if(snapshot.hasError) {
              return Center(
                  child: Text("Aucune connexion disponible", style: TextStyle(color: Colors.redAccent, fontSize: 16.0))
              );
            }
            if(initListLocation.length==0) {
              return Center(
                  child: Text("Aucune demande de location trouvée", style: TextStyle(color: Colors.orange, fontSize: 16.0))
              );
            }
            if(snapshot.hasData) {
              if(objLocation.length==0){
                objLocation = snapshot.data ?? [];
              }else{
                objLocation = objLocation.toList();
              }
              return ListView.builder(
                  physics: BouncingScrollPhysics(),
                  controller: _scrollController,
                  itemCount: loading ? objLocation.length + 1 : objLocation.length,
                  itemBuilder: (context,i){

                    if (objLocation.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Location nDataList = objLocation[i];
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



  Widget BuildTableCard(BuildContext context, Location item, int index) {
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
                Text(" Vous êtes sollicite pour un travail", style: GoogleFonts.questrial(
                  fontSize: 18.0,
                  fontWeight: FontWeight.w500,
                  color: Color(0xF8F6894D),
                  wordSpacing: 2.5,
                )),
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
                            showAlert(item);
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
                  item.pays+", "+item.province+", "+item.ville,
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
                        'Démandé le :',
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
                      Icons.timer,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Heure/jrs :",
                        style: Constante.style4,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.heureTravail.toString() ,
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
                    Icon(
                      Icons.monetization_on_rounded,
                      size: 17,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Rémuneration :',
                        style: Constante.style4,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      item.remunerationCdt.toString()+" \$ ",
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
                        'Status :',
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



  Widget setStatus(Location item){
    String msg=""; Color colors=Colors.orange;
    if(item.avisCandidat==0 && item.avisClient==0){
      msg="Veuillez confirmer cette demande"; colors= Colors.blue ;
    }else if(item.avisCandidat==2 && item.avisClient==0){
      msg="En attente de confirmation par l'intérésser"; colors= Colors.orange;
    }else if(item.avisCandidat==2 && item.avisClient==2){
      msg="Demande accepter vous êtes en poste"; colors= Colors.green;
    }else if(item.avisCandidat==3){
      msg="Vous avez refuser cette demande"; colors= Colors.red;
    }else if(item.avisClient==3){
      msg="Demande annuler par l'employeur"; colors= Colors.red ;
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
              fontSize: 12.0,
            ),
          ),
        ),
      ],
    );


  }

  void showAlert(Location item) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 400,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Détails sur la demande de location", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black87, fontSize: 16),
                ),
                SizedBox(height: 20,),
                _buildButtonColumn2( Icons.date_range,item.dateDebut, "Date début",  Colors.black45, 13 ),
                Divider(),
                SizedBox(height: 15,),
                _buildButtonColumn2( Icons.date_range,item.dateFin, "Date fin",  Colors.black45, 13 ),
                Divider(),
                SizedBox(height: 15,),
                _buildButtonColumn2( Icons.settings_system_daydream,item.journeeLocation, "Journée(s) de travail",  Colors.black45, 13 ),
                Divider(),
                SizedBox(height: 10,),
                _buildButtonColumn2( Icons.timelapse, item.periode +" jour(s)", "Nombre de jour de travail",  Colors.black45, 13 ),
                Divider(),
                SizedBox(height: 10,),
                _buildButtonColumn2( Icons.timer,item.heureTravail+" heure(s)", "Heure de travail/jour",  Colors.black45, 13 ),
                Divider(),
              ],
            ),
          ),


        ),
      ),
    );
  }

  Column _buildButtonColumn2(IconData icon, String label, String text, Color color, double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
       Constante.TextwithIcon(icon, text, color, size),
        Container(
          margin: const EdgeInsets.only(top:0, left: 10, right: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }



}
