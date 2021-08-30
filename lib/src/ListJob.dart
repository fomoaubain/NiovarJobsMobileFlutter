import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Job.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/AbonnementPage.dart';
import 'package:niovarjobs/src/DetailsJob.dart';
import 'package:niovarjobs/src/ListJob.dart';
import 'package:niovarjobs/src/PageCompagny.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/widget/company_card.dart';
import 'package:niovarjobs/widget/company_card2.dart';

import 'drawer/drawer_header.dart';
import 'package:http/http.dart' as http;

class ListJob extends StatefulWidget {

  @override
  _ListJob createState() => _ListJob();
}

class _ListJob extends State<ListJob> {
  ScrollController _scrollController = new ScrollController();
  late List<Postuler> objJob=[],  initListJob=[];
  late Future<List<Postuler>>  listOffreRecent;
  var loading = false;

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


      initListJob=  listModel;

    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listOffreRecent= this.fetchItem('RestJob/listoffrerecent?token='+Constante.token);
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
          "Toutes nos offres",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        child:FutureBuilder<List<Postuler>>(
          future: listOffreRecent,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.circularLoader();
            }
            if(snapshot.hasError) {
              return Center(
                  child: Text("Aucune connexion disponible", style: TextStyle(color: Colors.redAccent, fontSize: 16.0))
              );
            }
            if(initListJob.length==0) {
              return Center(
                  child: Text("Aucune offre d'emploi disponible", style: TextStyle(color: Colors.orange, fontSize: 16.0))
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
            return Constante.circularLoader();
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

                  Constante.makeVedette(postuler.job),
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
