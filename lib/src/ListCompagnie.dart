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

class ListCompagnie extends StatefulWidget {

  @override
    _ListCompagnie createState() => _ListCompagnie();
}

class _ListCompagnie extends State<ListCompagnie> {
  ScrollController _scrollController = new ScrollController();
  late List<Inscrire> objInscrire=[];
  late Future<List<Inscrire>>  listCompagnie;
  late List<Inscrire> initListInscrire=[];
  var loading = false;


  Future<List<Inscrire>> fetchItemInscire(String urlApi) async {
    List<Inscrire> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Inscrire.fromJson(element));
        });
      }
    }

    initListInscrire = listModel;
    return listModel.take(8).toList();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listCompagnie= this.fetchItemInscire('RestJob/listcompagnie?token='+Constante.token);
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
      objInscrire = initListInscrire.take(objInscrire.length+8).toList();
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
          "Compagnies recommandées",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: Container(
        child:FutureBuilder<List<Inscrire>>(
          future: listCompagnie,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerVertical(10);

            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => ListCompagnie()))

              );
            }
            if(initListInscrire.length==0) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune compagnie disponible")
              );
            }
            if(snapshot.hasData) {
              if(objInscrire.length==0){
                objInscrire = snapshot.data ?? [];
              }else{
                objInscrire = objInscrire.toList();
              }

              return ListView.builder(
                  controller: _scrollController,
                  itemCount: loading ? objInscrire.length + 1 : objInscrire.length,
                  itemBuilder: (context,i){
                    if (objInscrire.length == i){
                      return Center(
                          child: CupertinoActivityIndicator()
                      );
                    }
                    Inscrire nDataList = objInscrire[i];
                    return Container(
                      child: Card(
                        elevation: 0.0,
                        margin: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child: makeListTileCompagnie(nDataList),
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

  ListTile makeListTileCompagnie(Inscrire inscrire) => ListTile(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Card(
        child: CachedNetworkImage(
          width: 60.0,
          imageUrl: Constante.serveurAdress+inscrire.profilCompagnie,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    ),
    title: Text(
      inscrire.login,
      style: TextStyle(color: Colors.blue[900], fontWeight: FontWeight.bold, fontSize: 16.0),
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
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.location_on,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: inscrire.pays +', '  + inscrire.province +', '  + inscrire.ville,
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.phone,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: inscrire.telRepresentant,
                        )
                      ],
                    ),
                  ),

                ],
              ),

            )),


      ],
    ),
    trailing:
    Icon(Icons.visibility,
        color: Colors.orange[700], size: 30.0),
    onTap: () {

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => PageCompagny( inscrire.id,)));
    },
  );
}
