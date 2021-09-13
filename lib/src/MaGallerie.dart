import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:niovarjobs/model/Avis.dart';
import 'package:niovarjobs/model/Gallerie.dart';
import 'package:niovarjobs/model/Notification.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/widget/ViewImage.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart' as session;

class MaGallerie extends StatefulWidget {
  late var idIns;
  MaGallerie(this.idIns);

  @override
  _MaGallerie createState() => _MaGallerie();
}

class _MaGallerie extends State<MaGallerie> {

  ScrollController _scrollController = new ScrollController();
  late List<Gallerie> objGallerie=[],  initListGallerie=[];
  late Future<List<Gallerie>>  listGallerie;
  var loading = false;


  Future<List<Gallerie>> fetchItem(String id) async {
    List<Gallerie> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+'RestPage/MaGalerieHome/'+id));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Gallerie.fromJson(element));
        });
      }
    }
    initListGallerie=  listModel;

    return listModel.take(8).toList();
  }

  @override
  void initState() {
    super.initState();
    listGallerie= this.fetchItem(widget.idIns);
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
      objGallerie = initListGallerie.take(objGallerie.length+8).toList();
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
            child:FutureBuilder<List<Gallerie>>(
              future: listGallerie,
              builder: (context, snapshot) {
                if(snapshot.connectionState != ConnectionState.done) {
                  return Constante.circularLoader();
                }
                if(snapshot.hasError) {
                  return Center(
                      child: Text("Aucune connexion disponible", style: TextStyle(color: Colors.redAccent, fontSize: 16.0))
                  );
                }
                if(initListGallerie.length==0) {
                  return Center(
                      child: Text("Aucune image trouvée", style: TextStyle(color: Colors.orange, fontSize: 16.0))
                  );
                }
                if(snapshot.hasData) {
                  if(objGallerie.length==0){
                    objGallerie = snapshot.data ?? [];
                  }else{
                    objGallerie = objGallerie.toList();
                  }
                  return ListView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _scrollController,
                      itemCount: loading ? objGallerie.length + 1 : objGallerie.length,
                      itemBuilder: (context,i){
                        if (objGallerie.length == i){
                          return Center(
                              child: CupertinoActivityIndicator()
                          );
                        }
                        Gallerie nDataList = objGallerie[i];
                        return buildGallerieCard(i, nDataList);
                      }
                  );
                }
                // By default, show a loading spinner.
                return Constante.circularLoader();
              },
            ),
          ),
        ),
      )
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
                    Text(item.Pseudo,style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),),
                    SizedBox(height: 5,),
                    Text(item.libelle,style: Constante.style6.copyWith(fontWeight: FontWeight.w600),),
                    SizedBox(height: 5,),
                    Text("Ajoutée le : "+item.created,style: Constante.style6.copyWith(fontWeight: FontWeight.w300),),
                    Container(
                      alignment: Alignment.topRight,
                      child: SizedBox(),
                    )


                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }



  Widget buildGallerieCard(int index, Gallerie item) {

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      elevation: 4,
      shadowColor: Constante.primaryColor,
      child: InkWell(
        onTap: () {
        },
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: double.infinity,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange.withOpacity(.5)),
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Card(
                  child: CachedNetworkImage(
                    imageUrl: Constante.serveurAdress+item.image.toString(),
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Row(
                  children: [
                    Text('Titre:    ',style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.w900),),
                    Text(item.libelle,style: Constante.kTitleStyle,),
                  ],
                ),
              ),

              Align(alignment: Alignment.topRight, child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: customButton('Voir', (){
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => ViewImage(item.image.toString())));
                }),
              )),
            ],
          ),
        ),
      ),
    );
  }

  Widget customButton(text,function){
    return Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        color: Colors.orange,
        child: InkWell( onTap: function,
          child: Container(
            height: 35,
            width: double.infinity,
            child: Center(
                child: Icon(Icons.remove_red_eye, color: Colors.white,)
            ),
          ),
          borderRadius: BorderRadius.circular(10),
        )
    );
  }
}