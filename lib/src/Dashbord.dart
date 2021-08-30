import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:niovarjobs/Global.dart' as session;

import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/src/profil.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';
import 'GridDashbord.dart';
import 'LoginPage.dart';

class Dashbord extends StatefulWidget {

  @override
  _Dashbord createState() => _Dashbord();
}

class _Dashbord extends State<Dashbord> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
          "Mon panel",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body: Column(
        children: <Widget>[
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.only(left: 16, right: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: [
                        profilLogin(),
                        Text.rich(
                          TextSpan(
                            style: GoogleFonts.questrial(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w500,
                              color: Color(0xF8F6894D),
                            ),
                            children: [
                              TextSpan(
                                text: "  " + session.login,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                  ],
                ),

              ],
            ),
          ),
          SizedBox(height: 20),
          //TODO Grid Dashboard
          GridDashboard(),
        ],
      ),


    );


  }

  Widget profilLogin(){
    return  InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Profil()));
      },
      child:Container(
        height: 40,
        width: 50,
        child: CircleAvatar(
          radius: 30.0,
          backgroundImage:
          NetworkImage(Constante.serveurAdress+session.profil),
          backgroundColor: Colors.transparent,
        ),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Constante.kBlack.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 4,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
      ),
    );


  }
}

