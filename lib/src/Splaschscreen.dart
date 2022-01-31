import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:niovarjobs/src/homePage.dart';

class Splaschscreen extends StatefulWidget {
  Splaschscreen({ Key? key,  required this.title}) : super(key: key);

  final String title;

  @override
  _Splaschscreen createState() => _Splaschscreen();

}

class _Splaschscreen extends  State<Splaschscreen>{

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 4),
            (){
              Navigator.pop(context);
              Navigator.push(context,MaterialPageRoute(builder: (context)=>homePage(title: '')) );
            }
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center ,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/logo.png', height: 100.0),
          SizedBox(height: 10.0,),
          SpinKitRipple(
            size: 20,
            color: Colors.orange,
          ),

        ],
      ) ,

    );
  }


}
