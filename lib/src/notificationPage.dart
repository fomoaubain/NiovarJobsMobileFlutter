import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:niovarjobs/model/Notification.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;
import 'package:niovarjobs/Global.dart' as session;

import 'LoginPage.dart';

class NotificationPage extends StatefulWidget {

  @override
  _NotificationPage createState() => _NotificationPage();
}

class _NotificationPage extends State<NotificationPage> {
  Future<void>? _launched;
  ScrollController _scrollController = new ScrollController();
  late List<Notifications> objNotifications=[],  initListNotifications=[];
  late Future<List<Notifications>>  listNotifications;
  var loading = false;


  Future<List<Notifications>> fetchItem() async {
    List<Notifications> listModel = [];

    final response = await http.get(Uri.parse(Constante.serveurAdress+'RestUser/GetNotifications/'+session.id));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Notifications.fromJson(element));
        });
      }
    }
    initListNotifications=  listModel;

    setState(() {
      session.nbreNotif=listModel.length;
    });

    return listModel.take(8).toList();
  }



  Future marqueLu(String id) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/ChangeStatusNotif?id="+id;
    var response = await dio.get(pathUrl);
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    if(!session.IsConnected){
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => LoginPage()));
    }
   listNotifications= this.fetchItem();
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
      objNotifications = initListNotifications.take(objNotifications.length+8).toList();
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
          "Mes notifications",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 15, right: 15),
          child: Container(
            width: double.infinity,
            height: 730,
            child: Container(
              child:FutureBuilder<List<Notifications>>(
                future: listNotifications,
                builder: (context, snapshot) {
                  if(snapshot.connectionState != ConnectionState.done) {
                    return Constante.ShimmerSimpleVertical(10);
                  }
                  if(snapshot.hasError) {
                    return Center(
                        child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => NotificationPage()))
                    );
                  }
                  if(initListNotifications.length==0) {
                    return Center(
                        child: Constante.layoutDataNotFound("Aucune notification trouvée")
                    );
                  }
                  if(snapshot.hasData) {
                    if(objNotifications.length==0){
                      objNotifications = snapshot.data ?? [];
                    }else{
                      objNotifications = objNotifications.toList();
                    }
                    return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        controller: _scrollController,
                        itemCount: loading ? objNotifications.length + 1 : objNotifications.length,
                        itemBuilder: (context,i){
                          if (objNotifications.length == i){
                            return Center(
                                child: CupertinoActivityIndicator()
                            );
                          }
                          Notifications nDataList = objNotifications[i];
                          return BuildHomeCard(context, nDataList, i);
                        }
                    );
                  }
                  // By default, show a loading spinner.
                  return Constante.ShimmerSimpleVertical(10);
                },
              ),
            ),
          ),
        ),
      ),
    );

  }

  Widget BuildHomeCard(BuildContext context, Notifications notifications, int index) {

    return InkWell(
      onTap: () async {
     await marqueLu(notifications.id.toString());
        setState(() {
          objNotifications.removeAt(index);
          session.nbreNotif=objNotifications.length;
        });
        if(notifications.routeApp.isNotEmpty){
          Navigator.pushNamed(context, notifications.routeApp.toString());
        }
      },
      child: Container(
        width:double.infinity,
        margin: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(topLeft: Radius.circular(20),bottomRight: Radius.circular(20),bottomLeft:Radius.circular(20),topRight:Radius.circular(20)),
          color: Constante.secondaryColor,
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Icon(Icons.notifications,size: 30,color: Colors.black45,),
            ),
            Expanded(
              child: Container(
                child: Padding(
                  padding: const EdgeInsets.only(top: 20,bottom: 20,left: 10,right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(notifications.description,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                      SizedBox(height: 5,),
                      Text("Récus le : "+notifications.created,style: Constante.style6.copyWith(fontWeight: FontWeight.w400),),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

  }

}