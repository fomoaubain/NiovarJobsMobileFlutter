import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Avis.dart';
import 'package:niovarjobs/model/Notification.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:niovarjobs/src/LoginPage.dart';
import 'package:niovarjobs/widget/AddAvis.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart' as session;

class MesAvis extends StatefulWidget {
  late var idIns;
   late Pages  pages;

  MesAvis(this.idIns, this.pages);

  @override
  _MesAvis createState() => _MesAvis();
}

class _MesAvis extends State<MesAvis> {
  late FToast fToast;
  ScrollController _scrollController = new ScrollController();
  late List<Avis> objAvis=[],  initListAvis=[];
  late Future<List<Avis>>  listAvis;
  var loading = false;


  Future<List<Avis>> fetchItem(String id) async {
    List<Avis> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+'RestPage/MesAvisHome/'+id));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Avis.fromJson(element));
        });
      }
    }
    initListAvis=  listModel;

    return listModel.take(8).toList();
  }

  @override
  void initState() {
    super.initState();
    listAvis= this.fetchItem(widget.idIns);
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
      objAvis = initListAvis.take(objAvis.length+8).toList();
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constante.kSilver,
      body: Container(
        margin: EdgeInsets.only(left: 5, right: 5),
        child: Container(
          width: double.infinity,
          height: 730,
          child: Container(
            child:FutureBuilder<List<Avis>>(
              future: listAvis,
              builder: (context, snapshot) {
                if(snapshot.connectionState != ConnectionState.done) {
                  return Constante.circularLoader();
                }
                if(snapshot.hasError) {
                  return Center(
                      child: Text("Aucune connexion disponible", style: TextStyle(color: Colors.redAccent, fontSize: 16.0))
                  );
                }
                if(initListAvis.length==0) {
                  return Center(
                      child: Text("Aucun avis trouvée", style: TextStyle(color: Colors.orange, fontSize: 16.0))
                  );
                }
                if(snapshot.hasData) {
                  if(objAvis.length==0){
                    objAvis = snapshot.data ?? [];
                  }else{
                    objAvis = objAvis.toList();
                  }
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: loading ? objAvis.length + 1 : objAvis.length,
                      itemBuilder: (context,i){
                        if (objAvis.length == i){
                          return Center(
                              child: CupertinoActivityIndicator()
                          );
                        }
                        Avis nDataList = objAvis[i];
                        return BuildHomeCard(context, nDataList);
                      }
                  );
                }
                // By default, show a loading spinner.
                return Constante.circularLoader();
              },
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          if(!session.IsConnected){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            return;
          }else{
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => AddAvis(widget.pages)));
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }


  Widget BuildHomeCard(BuildContext context, Avis item) {

    return Container(
      width:double.infinity,
      margin: EdgeInsets.symmetric(vertical: 5,horizontal: 7),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(topLeft: Radius.circular(0),bottomRight: Radius.circular(0),bottomLeft:Radius.circular(0),topRight:Radius.circular(0)),
        color: Constante.secondaryColor,
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Icon(Icons.account_circle,size: 30,color: Colors.black45,),
          ),
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child:Text(item.Pseudo,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),), ),
                        Expanded(child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,

                          children: [
                            for ( int i=0; i<item.nbreEtoile; i++)Icon(Icons.star, color: Colors.yellow, size: 15,)

                          ],
                        )),
                      ],
                    ),

                    SizedBox(height: 5,),
                    Text(item.libelle,style: Constante.style6.copyWith(fontWeight: FontWeight.w600),),
                    SizedBox(height: 5,),
                    Text("Ajoutée le : "+item.created,style: Constante.style6.copyWith(fontWeight: FontWeight.w300),),



                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

}