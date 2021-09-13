import 'dart:async';
import 'dart:io';

import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:photo_view/photo_view.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class ViewImage extends StatefulWidget {
  late String urlImage;
  ViewImage(this.urlImage);
  @override
  _ViewImage createState() => _ViewImage();
}

class _ViewImage extends State<ViewImage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constante.kSilver,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Constante.kSilver,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: Constante.kBlack,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: Container(
          child: PhotoView(
            imageProvider: NetworkImage(Constante.serveurAdress+widget.urlImage),
          )
      ),
    );

  }
}


