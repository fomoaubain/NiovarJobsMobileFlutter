import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:niovarjobs/model/Categorie.dart';
import 'package:niovarjobs/model/Gerant.dart';
import 'package:niovarjobs/model/Type.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:niovarjobs/Global.dart' as session;
import 'package:http/http.dart' as http;
import 'package:collection/collection.dart';

import '../Global.dart';
import 'homePage.dart';

class ManageAlerte extends StatefulWidget {
  @override
  _ManageAlerte createState() => _ManageAlerte();
}

class _ManageAlerte extends State<ManageAlerte> {

  String listIdChecked="";
  var loading = false;
  late FToast fToast;
  late List<SouscrireCat> initListSouscrireCat=[];
  late List<Types> initListType=[];
  late Future<List<Types>>  listType;
  List<Items> itemCheckedState = [];
  late String checkValue="";


  Future<List<Types>> fetchData(String idUser) async {
    List<Types> listModelType = [];
    List<SouscrireCat> listModelSouscrireCat = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+"RestUser/getSouscription?id="+idUser));
    if (response.statusCode == 200) {
      final dataType = jsonDecode(response.body)['datas'];
      if (dataType != null) {
        dataType.forEach((element) {
          listModelType.add(Types.fromJson(element));
        });
      }
      initListType = listModelType;
      final dataSouscrireCat = jsonDecode(response.body)['listsouscrire'];
      if (dataSouscrireCat != null) {
        dataSouscrireCat.forEach((element) {
          listModelSouscrireCat.add(SouscrireCat.fromJson(element));
        });
      }
    }
    initListSouscrireCat = listModelSouscrireCat;
    return listModelType.take(8).toList();
  }

  Future postAlerte(String IdTypes, String idUser) async {
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestUser/Setting";
    FormData formData = new FormData.fromMap({
      'IdTypes': IdTypes,
      'idUser': idUser
    });
    var response = await dio.post(pathUrl,
      data: await formData,
    );
    return response.data;
  }

  @override
  void initState() {
    super.initState();
    listType= fetchData(session.id);
    fToast = FToast();
    fToast.init(context);
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
          "Alertes emplois",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Container(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child:   Column(
            children: <Widget>[
              SizedBox(height: 10,),
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                child:  Text(
                  "Sélectionner les catégories que vous aimeriez reçevoir des alertes par courriel.",
                  style: Constante.style4.copyWith(fontSize: 16, color: Colors.black54),
                ),
              ),
              SizedBox(height: 15,),
              Container(
                margin: EdgeInsets.only(bottom: 60),
                width: double.infinity,
                child:FutureBuilder<List<Types>>(
                  future: listType,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState != ConnectionState.done) {
                      return Constante.circularLoader();
                    }
                    if(snapshot.hasError) {
                      return Center(
                          child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => ManageAlerte()))
                      );
                    }
                    if(initListType.length==0) {
                      return Center(
                          child: Constante.layoutDataNotFound("Aucune donnée trouvé")
                      );
                    }
                    if(snapshot.hasData) {
                      if(itemCheckedState.length==0){
                        for(int i = 0; i < initListType.length; i++){
                          var item = initListSouscrireCat.firstWhereOrNull((element) => element.Typ_id == initListType[i].id);
                          itemCheckedState.add( Items(id: initListType[i].id, state: item!=null ? true : false));
                        }
                      }

                      return ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          itemCount:  initListType.length,
                          itemBuilder: (context,i){
                            Types nDataList = initListType[i];
                            return CheckboxListTile(
                                value: itemCheckedState[i].state,
                                title: Text(nDataList.libelle),
                                onChanged: (newValue) {
                                  setState(() {
                                    itemCheckedState[i].state = newValue!;
                                  });
                                });
                          }
                      );
                    }
                    // By default, show a loading spinner.
                    return Constante.circularLoader();
                  },
                ),
              ),
            ],
          ),
        ),
      ),


      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          checkValue="";
          for(int i = 0; i < itemCheckedState.length; i++){
            if(itemCheckedState[i].state==true){
              checkValue=checkValue + itemCheckedState[i].id.toString()+",";
            }
          }
          if(checkValue.isEmpty){
            Constante.showSnackBarMessage(context, "Veuillez sélectionner au moins une catégorie");
            return;
          }

          Constante.showAlert(context, "Veuillez patientez", "Sauvegarde en cour...", SizedBox(), 100);
          await postAlerte(checkValue, session.id.toString()).then((value) async {
            if(value['result_code'].toString().contains("1")){
              Navigator.pop(context);
              Constante.showToastSuccess("Sauvegarde éffectué avec succès", fToast);
            }else{
              Navigator.pop(context);
              Constante.showAlert(context, "Note d'information", value['message'].toString(),
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
                      color:Colors.orange,
                    ),
                  ),
                  170);
            }

          });

        },
        child:  Icon(Icons.check),
      ),

    );
  }


}

class Items {
  var id;
  bool state;

  Items({ required this.id, required this.state});
}