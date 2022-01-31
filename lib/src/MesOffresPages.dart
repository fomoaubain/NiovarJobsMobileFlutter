import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'DetailsJob.dart';
import 'package:http/http.dart' as http;

class MesOffresPages extends StatefulWidget {
  late var idIns;
  MesOffresPages(this.idIns);
  @override
  _MesOffresPages createState() => _MesOffresPages();
}

class _MesOffresPages extends State<MesOffresPages> {
  ScrollController _scrollController = new ScrollController();
  late List<Postuler> objJob=[],  initListJob=[];
  late Future<List<Postuler>>  listOffreRecent;
  var loading = false;

  Future<List<Postuler>> fetchItem(String id) async {
    List<Postuler> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+"RestPage/MyPageOffre/"+id.toString()));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];

      if (data != null) {
        data.forEach((element) {
          listModel.add(Postuler.fromJson(element));
        });
      }
    }
    initListJob=  listModel;

    return listModel.take(8).toList();
  }


  @override
  void initState() {
    super.initState();
    listOffreRecent= this.fetchItem(widget.idIns.toString());
    _scrollController.addListener(_onScroll);
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
      objJob = initListJob.take(objJob.length+8).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:FutureBuilder<List<Postuler>>(
          future: listOffreRecent,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => MesOffresPages(widget.idIns)))
              );
            }
            if(initListJob.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune offre d'emploi disponible")
              );
            }
            if(snapshot.hasData) {
              if(objJob.length==0){
                objJob = snapshot.data ?? [];
              }else{
                objJob = objJob.toList();
              }
              return ListView.builder(
                  controller: _scrollController,
                  itemCount: loading ? objJob.length + 1 : objJob.length,
                  itemBuilder: (context,i){

                    if (objJob.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Postuler nDataList = objJob[i];
                    return Container(
                      child: Card(
                        elevation: 0.0,
                        margin: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child:makeListTile(nDataList),
                        ),
                      ),
                    );
                  }
              );
            }
            // By default, show a loading spinner.
            return Constante.ShimmerVertical(10);
          },
        ),
      ),
    );

  }
  ListTile makeListTile(Postuler postuler) => ListTile(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Card(
        child: CachedNetworkImage(

          width: 60.0,
          imageUrl: Constante.serveurAdress+postuler.inscrire.profilName,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    ),
    title: Text(
      postuler.job.titre,
      style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 16.0),
    ),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 12,
            child: Container(
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                          fontWeight: FontWeight.bold
                      ),
                      children: [
                        TextSpan(
                          text: Constante.getSalaire(postuler.job),
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.location_on,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: postuler.job.pays+", "+ postuler.job.province +", "+postuler.job.ville,
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.calendar_today,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: "Publié le : "+postuler.job.created,
                        )
                      ],
                    ),
                  ),

                  Constante.makeJobUgentOrInstantane(postuler.job),
                ],
              ),

            )),


      ],
    ),
    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.orange[700], size: 30.0),
    onTap: () {

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailsJob( idJob: postuler.job.id,forVisit: false)));
    },
  );
}


