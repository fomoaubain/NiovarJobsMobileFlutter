import 'dart:async';
import 'dart:io';

import 'package:flutter_html/flutter_html.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/model/Pages.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class PourquoiPostuler extends StatefulWidget {
  late Pages pages;
  PourquoiPostuler(this.pages);
  @override
    _PourquoiPostuler createState() => _PourquoiPostuler();
}

class _PourquoiPostuler extends State<PourquoiPostuler> {

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
                    'Pourquoi postuler chez nous ?',
                    style: Constante.kTitleStyle,
                  )),
              SizedBox(
                height: 20,
              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                child: SingleChildScrollView(
                  child: Html(
                    data: widget.pages.pourquoiPostuler.toString(),
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


