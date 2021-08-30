import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:niovarjobs/src/homePage.dart';

class MyHeaderDrawer extends StatefulWidget {

@override
_MyHeaderDrawer createState() => _MyHeaderDrawer();

}

class _MyHeaderDrawer extends  State<MyHeaderDrawer>{

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
     color:  Colors.orange[700],
      width: double.infinity,
      height: 200.0,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
             decoration:  BoxDecoration(
               shape:BoxShape.circle,
               image:  DecorationImage(
                 image: AssetImage('assets/profil.jpeg'),
               )
             ),
          ),
          Text('Pseudo', style: TextStyle(color: Colors.white, fontSize: 20)),
          Text('niovarjobs@gmail.com', style: TextStyle(color: Colors.grey[200], fontSize: 14)),


        ],
      ),



    );
  }


}
