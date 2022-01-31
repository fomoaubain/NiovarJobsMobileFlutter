import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:niovarjobs/model/FAQ.dart';
import 'package:video_box/video.controller.dart';
import 'package:video_box/video_box.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'package:http/http.dart' as http;

class FaqPage extends StatefulWidget {

  @override
  _FaqPage createState() => _FaqPage();
}

class _FaqPage extends State<FaqPage> {
  late List<FAQ> objFaq=[];
  late Future<List<FAQ>>  listFaqRecent;
  List<VideoController> vcs = [];

  @override
  void initState() {
    super.initState();
    listFaqRecent= this.fetchItem('RestJob/FaqPage');
  }

  Future<List<FAQ>> fetchItem(String urlApi) async {
    List<FAQ> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(FAQ.fromJson(element));
          vcs.add(VideoController(source: VideoPlayerController.network(Constante.serveurAdress+FAQ.fromJson(element).video.toString()))
            ..initialize());
        });
      }
    }
    return listModel.toList();
  }

  @override
  void dispose() {
    for (var vc in vcs) {
      vc.dispose();
    }
    super.dispose();
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
          "Comment sa marche ?",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Container(
        child:FutureBuilder<List<FAQ>>(
          future: listFaqRecent,
          builder: (context, snapshot) {
            if(snapshot.connectionState != ConnectionState.done) {
              return Constante.ShimmerSimpleVertical(10);
            }
            if(snapshot.hasError) {
              return Center(
                  child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => FaqPage()))
              );
            }
            if(!snapshot.hasData) {
              return Center(
                  child: Constante.layoutDataNotFound("Aucune donnée trouvée")
              );
            }
            if(snapshot.hasData) {
              objFaq = snapshot.data ?? [];

              return ListView.builder(
                  itemCount: objFaq.length,
                  itemBuilder: (context,i){
                    FAQ nDataList = objFaq[i];
                    return Container(
                      child: Card(
                        elevation: 0.0,
                        margin: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                        child: Container(
                          decoration: BoxDecoration(color: Colors.white),
                          child:makeListTile(nDataList, i),
                        ),
                      ),
                    );
                  }
              );
            }
            // By default, show a loading spinner.
            return Constante.ShimmerSimpleVertical(10);
          },
        ),
      ),
    );
  }

  ExpansionTile makeListTile(FAQ item , int index){
    bool showTextBool=false, showImageWithTextBool=false, showVideoWithTextBool=false, showVideoWithImageWithTextBool=false,
        showImageBool =false, showVideoBool=false;
    Widget widget;
    if(item.reponce.toString().isNotEmpty && item.image.toString().isEmpty && item.video.toString().isEmpty){
      showTextBool=true;
    }
    if(item.reponce.toString().isNotEmpty && item.image.toString().isNotEmpty && item.video.toString().isEmpty){
      showImageWithTextBool=true;
    }
    if(item.reponce.toString().isNotEmpty && item.image.toString().isEmpty && item.video.toString().isNotEmpty){
      showVideoWithTextBool=true;
    }
    if(item.reponce.toString().isNotEmpty && item.image.toString().isNotEmpty && item.video.toString().isNotEmpty){
      showVideoWithImageWithTextBool=true;
    }
    if(item.reponce.toString().isEmpty && item.image.toString().isNotEmpty && item.video.toString().isEmpty){
      showImageBool=true;
    }

    if(item.reponce.toString().isEmpty && item.image.toString().isEmpty && item.video.toString().isNotEmpty){
      showVideoBool=true;
    }

    return  ExpansionTile(
      tilePadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      title: Text(
          item.question.toString(),
          style: Constante.kTitleStyle
      ),
      iconColor: Constante.primaryColor,
      collapsedIconColor:Constante.primaryColor,
      textColor: Constante.kBlack,
      children: <Widget>[
        showTextBool ? showText(item) : SizedBox(),
        showImageWithTextBool ? showImageWithText(item) : SizedBox(),
        showVideoWithTextBool ? showVideoWithText(item,index) : SizedBox(),
        showVideoWithImageWithTextBool ? showVideoWithImageWithText(item,index) : SizedBox(),
        showImageBool ? showImage(item) : SizedBox(),
        showVideoBool ? showVideo(item,index) : SizedBox(),
      ],
    );
  }


  Widget showText(FAQ item){
    return  ListTile(
      title:  Html(
        data: item.reponce,
      ),
    );
  }

  Widget showImage(FAQ item){
    return  Container(
      height: 140.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.withOpacity(.5)),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        child: CachedNetworkImage(
          imageUrl: Constante.serveurAdress+item.image,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    );
  }

  Widget showVideo(FAQ item, int index){
    return  Container(
      height: 140.0,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.orange.withOpacity(.5)),
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Card(
        child:AspectRatio(
          aspectRatio: 16 / 9,
          child: VideoBox(controller: vcs.elementAt(index)),
        ),
      ),
    );
  }

  Widget showImageWithText(FAQ item){
    return  Container(
      child: Row(
        children: [
          Expanded(
              child:showImage(item),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                child: Html(
                  data: item.reponce,
                ),
              )
            ],
          ),)
        ],
      ),
    );
  }

  Widget showVideoWithText(FAQ item, int index){
    return  Container(
      child: Row(
        children: [
          Expanded(
            child:showVideo(item, index),
          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                child: Html(
                  data: item.reponce,
                ),
              )
            ],
          ),)
        ],
      ),
    );
  }

  Widget showVideoWithImageWithText(FAQ item, int index){
    return  Container(
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                showImage(item),
                SizedBox(height: 15,),
                showVideo(item, index)
              ],
            ),

          ),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                child: Html(
                  data: item.reponce,
                ),
              )
            ],
          ),)
        ],
      ),
    );
  }


}