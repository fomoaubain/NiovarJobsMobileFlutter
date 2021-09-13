import 'dart:async';
import 'dart:io';

import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class Apropos extends StatefulWidget {
 late Pages pages;
 Apropos(this.pages);
  @override
  _Apropos createState() => _Apropos();
}

class _Apropos extends State<Apropos> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'A propos de notre compagnie',
                    style: Constante.kTitleStyle,
                  )),
              SizedBox(
                height: 20,
              ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
            child: SingleChildScrollView(
              child: Html(
                data: widget.pages.aPropos.toString(),
              ),
            ),

          ),

            ],
          ),
        ),
      ),
    );

  }
}


