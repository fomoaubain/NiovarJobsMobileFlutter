import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Gerant.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;
import 'package:http/http.dart' as http;

import 'homePage.dart';

class ManageGerant extends StatefulWidget {

  @override
  _ManageGerant createState() => _ManageGerant();
}

class _ManageGerant extends State<ManageGerant> {

  ScrollController _scrollController = new ScrollController();
  late List<Gerant> objGerant=[],  initListGerant=[];
  late Future<List<Gerant>>  listGerant;
  var loading = false;
  late FToast fToast;

  Future<List<Gerant>> fetchItem(String urlApi) async {
    List<Gerant> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Gerant.fromJson(element));
        });
      }
    }
    initListGerant=  listModel;
    return listModel.take(8).toList();
  }

  @override
  void initState() {
    super.initState();
    listGerant= this.fetchItem('RestJob/MesCandidatures?id='+session.id);
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
      objGerant = initListGerant.take(objGerant.length+8).toList();
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
          "Mes utilisateurs",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Container(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {

        },
        child:  Icon(Icons.add),
      ),

    );
  }


}