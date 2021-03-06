import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Job.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/DetailsJob.dart';
import 'package:niovarjobs/src/LoginPage.dart';
import 'package:niovarjobs/src/PageCompagny.dart';
import 'package:niovarjobs/src/PostulerDirectement.dart';
import 'package:niovarjobs/src/homePage.dart';
import 'package:niovarjobs/widget/company_tab.dart';
import 'package:niovarjobs/widget/description_tab.dart';
import 'package:niovarjobs/Global.dart' as session;
import 'package:shared_preferences/shared_preferences.dart';

import 'ListCompagnie.dart';
import 'MesCandidatures.dart';
import 'drawer/drawer_header.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_html/flutter_html.dart';
class DetailsJob extends StatefulWidget {
  var idJob;
  bool forVisit;
  DetailsJob({ required this.idJob, required this.forVisit});

  @override
  _DetailsJob createState() => _DetailsJob(idJob, forVisit);
}

class _DetailsJob extends State<DetailsJob> {
  late FToast fToast;
  late Postuler postuler ;
  var idJob;
  bool forVisit;
  bool _showLoading = true;

  _DetailsJob(this.idJob, this.forVisit);

 late Postuler initPostuler;

  Future postCandidature(String idUser, String idJob, String companyId) async{
    Dio dio = new Dio();
    final String pathUrl = Constante.serveurAdress+"RestJob/postuler";
    FormData formData = new FormData.fromMap({
      "idUser": idUser,
      "idJob": idJob,
      "companyId": companyId,
    });

    var response = await dio.post(pathUrl,
      data: await formData,
    );
    return response.data;
  }

  Future _fetchData(String id) async {
    List<Postuler> listModel = [];
    final responsePostuler = await http.get(Uri.parse(Constante.serveurAdress+"RestJob/getDetailsOffre/"+id.toString()));
    if (responsePostuler.statusCode == 200) {
      final data = jsonDecode(responsePostuler.body)['postuler'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Postuler.fromJson(element));
        });
        setState(() {
          postuler =listModel.first;
          initPostuler=postuler;
          _showLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();

    fToast = FToast();
    fToast.init(context);
    _fetchData(this.idJob.toString());
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
         _showLoading ? "" : Constante.getCompanyName(postuler),
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: _showLoading ? Constante.circularLoader() : Container(
          width: double.infinity,
          // margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(40.0),
              topRight: Radius.circular(40.0),
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                constraints: BoxConstraints(maxHeight: 170.0),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: [
                        Expanded(
                            child:Container(
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              width: 100.0,
                              height: 100.0,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.orange.withOpacity(.5)),
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              child: Card(
                                child: CachedNetworkImage(
                                  imageUrl: Constante.serveurAdress+postuler.inscrire.profilName,
                                  placeholder: (context, url) => CupertinoActivityIndicator(),
                                  errorWidget: (context, url, error) => Icon(Icons.error),
                                ),
                              ),
                            ),
                        ),
                        Expanded(
                            child: Container(
                              child:Column(
                                children: [
                                  Text(
                                    initPostuler.job.titre,
                                    style: Constante.kTitleStyle.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 5.0),
                                  TextwithIcon(Icons.location_on,postuler.job.pays+ ", " +postuler.job.province +", " +  postuler.job.ville , Colors.black45,12),
                                  TextwithIcon(Icons.date_range, postuler.job.created, Colors.black45,12),
                                  Constante.makeJobUgentOrInstantane(postuler.job),
                                ],
                              ) ,
                            ),
                        ),
                      ],
                    ),
                    SizedBox(height: 5.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                    ),
                    SizedBox(height: 10.0),
                    Material(
                      color: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        side: BorderSide(
                          color: Constante.kBlack.withOpacity(.2),
                        ),
                      ),
                      // borderRadius: BorderRadius.circular(12.0),
                      child: TabBar(
                        unselectedLabelColor: Constante.kBlack,
                        indicator: BoxDecoration(
                          color: Colors.orange[700],
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        tabs: [
                          Tab(text: "Description"),
                          Tab(text: "Plus d??tails"),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: 0.0),
              Expanded(
                child: TabBarView(
                  children: [
                    DescriptionTab(postuler:postuler ),
                    CompanyTab(postuler: postuler),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      bottomNavigationBar: _showLoading ? SizedBox() : forVisit? SizedBox() : postuleButton(postuler),
    );


  }



  Text makeVedette(Job job){
    String val = '';
    if(job.vedette.contains("1")){
      val='En vedette';
    }
    return Text(val, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12.0));
  }

  Text TextwithIcon(IconData icon, String text, Color colors, double textsize){
    return  Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: textsize,
            color: colors
        ),
        children: [
          WidgetSpan(
            child: Icon(icon,color:Colors.orange, size: 14.0,),
          ),
          TextSpan(
            text: text,
          )
        ],
      ),
    );
  }


  Widget postuleButton(Postuler postuler){
    return  PreferredSize(
      preferredSize: Size.fromHeight(60.0),
      child: Container(
        padding: EdgeInsets.only(left: 18.0, bottom: 25.0, right: 18.0),
        // margin: EdgeInsets.only(bottom: 25.0),
        color: Colors.white,
        child: Row(
          children: <Widget>[
            Container(
              width: 50.0,
              height: 50.0,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.orange.withOpacity(.5)),
                borderRadius: BorderRadius.circular(12.0),
              ),
              child:  InkWell(
                onTap: () {
                  if(postuler.job.immediat.isNotEmpty && postuler.job.immediatLabel.toString()!="direct"){
                    Navigator.push(
                        context, MaterialPageRoute(builder: (context) => PageCompagny(postuler.inscrire.id)));
                  }else{
                    Constante.showToastError("Cette compagnie ne poss??de pas de page.", fToast);

                  }

                },
                child: Icon(
                  Icons.home_work_outlined,
                  color: Colors.black45,
                ),
              ),
            ),

            SizedBox(width: 15.0),
            Expanded(
              child: SizedBox(
                height: 50.0,
                child: RaisedButton(
                  onPressed: () async{
                    if(!session.IsConnected){
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => LoginPage()));
                      return;
                    }
                    if(session.type=="client"){
                      ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Veuillez vous connectez avec un compte candidat pour envoyer votre cv'),
                            backgroundColor: Colors.black87,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          )
                      );
                      return;
                    }else{
                      if(postuler.job.immediatLabel=="direct"){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => PostulerDirectement(postuler)));
                      }else{
                        Constante.showAlert(context, "Veuillez patientez", "Envoie de votre candidature en cour...", SizedBox(), 100);
                        await postCandidature(session.id, postuler.job.id.toString(), postuler.inscrire.id.toString(),).then((value){
                          if(value['result_code'].toString().contains("1")){
                            Navigator.pop(context);
                            Constante.showAlert(context, "Note d'information", "Votre candidature ?? ??t?? envoyer avec succ??s. ",
                                SizedBox(
                                  child: RaisedButton(
                                    padding: EdgeInsets.all(10),
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                          context, MaterialPageRoute(builder: (context) => MesCandidatures()));
                                    },
                                    child: Text(
                                      "Voir mes candidatures",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    color:Colors.orange,
                                  ),
                                ),
                                170);
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
                        }
                        );
                      }
                    }
                  },
                  color: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Text(
                    postuler.job.immediatLabel=="direct" ? "Postuler directement": "Postuler maintenant",
                    style: Constante.kTitleStyle.copyWith(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }



}