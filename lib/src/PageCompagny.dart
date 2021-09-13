import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/Apropos.dart';
import 'package:niovarjobs/src/MaGallerie.dart';
import 'package:niovarjobs/src/MesAvis.dart';
import 'package:niovarjobs/src/MesOffresPages.dart';
import 'package:niovarjobs/src/PourquoiPostuler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;

import 'package:url_launcher/url_launcher.dart';


class PageCompagny extends StatefulWidget {
late int idIns;
PageCompagny(this.idIns);

  @override
  _PageCompagny createState() => _PageCompagny();
}

class _PageCompagny extends State<PageCompagny> {
  Future<void>? _launched;
  bool _showLoading = true;
   late Pages currentPage;
   late var abonnementRecommander;
  late String nomCompanie="";

  Future _fetchCompagny(String id) async {
    Pages model;
    final responsePostuler = await http.get(Uri.parse(Constante.serveurAdress+"RestPage/Company/"+id.toString()));
    if (responsePostuler.statusCode == 200) {
      final data = jsonDecode(responsePostuler.body)['Page'];
      if (data != null) {
        model= Pages.fromJson(data);
        setState(() {
          currentPage =model;
          nomCompanie= currentPage.company.nom.toString();
          abonnementRecommander=jsonDecode(responsePostuler.body)['AbonnementRecommander'];
          _showLoading = false;
        });
      }
    }
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchCompagny(widget.idIns.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _showLoading ? Constante.circularLoader() :  DefaultTabController(
          length: 5,
          child: Scaffold(
            backgroundColor: Constante.kSilver,
            appBar: AppBar(
              backgroundColor: Constante.kSilver,
              leading: IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Constante.kBlack,
                ),
                onPressed: () => Navigator.pop(context),
              ),
              elevation: 0,
              toolbarHeight: 180,
              centerTitle: true,
              title: Padding(
                padding: const EdgeInsets.all(4.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60.0,
                          height: 60.0,
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.orange.withOpacity(.5)),
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Card(
                            child: CachedNetworkImage(
                              imageUrl: Constante.serveurAdress+currentPage.company.profilName,
                              placeholder: (context, url) => CupertinoActivityIndicator(),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),
                        ),
                        SizedBox(width: 20,),
                        Text(
                          currentPage.company.nom.toString(),
                          style: Constante.kPageTitleStyle.copyWith(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      children: [
                      abonnementRecommander.toString().isNotEmpty && abonnementRecommander.toString()=="1" ?  Expanded(
                          child: InkWell( onTap: (){},
                            child: Container(
                              height: 30,
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              decoration:  BoxDecoration(color: Colors.green,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(child: Text('Cette Compagnie est Verifiee et recommandee',style: TextStyle(fontSize: 12,color: Constante.secondaryColor),)),
                            ),
                          ),
                        ) : SizedBox(width: 20,),
                        SizedBox(width: 10,),
                        InkWell( onTap: () async {
                          _launched = _launchInBrowser(currentPage.company.facebook.toString());
                        },
                          child: Container(height: 30,width: 30,
                            decoration:  BoxDecoration(color: Colors.blue,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(child: FaIcon(FontAwesomeIcons.facebookF,size: 20,)),
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell( onTap: () async {
                          _launched = _launchInBrowser(currentPage.company.linkedin.toString());
                        },
                          child: Container(height: 30,width: 30,
                            decoration:  BoxDecoration(color: Colors.red,
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(child: FaIcon(FontAwesomeIcons.linkedinIn,size: 20,)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              bottom: TabBar(
                  unselectedLabelColor: Constante.kBlack,
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(10), color: Colors.orange),
                  tabs: [
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.info,
                              size: 18,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text("A propos",style: TextStyle(fontSize: 9,fontWeight: FontWeight.bold),)
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.image,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Gallerie",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.list,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Avis",
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              FontAwesomeIcons.check,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Pourquoi\npostuler ?",
                              style: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Tab(
                      child: Align(
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            Icon(
                              Icons.send,
                              size: 20,
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Nos offres d'emploi",
                              style: TextStyle(
                                  fontSize: 8, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ]),
            ),
            body: TabBarView(children: [
             Apropos(currentPage),
              MaGallerie(widget.idIns.toString()),
              MesAvis(widget.idIns.toString(), currentPage),
              PourquoiPostuler(currentPage),
              MesOffresPages(widget.idIns.toString()),

            ]),
          )),
    );

  }
}


