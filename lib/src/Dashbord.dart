import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/svg.dart';
import 'package:niovarjobs/Global.dart' as session;

import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/src/GridDashboardClient.dart';
import 'package:niovarjobs/src/profil.dart';
import 'package:url_launcher/url_launcher.dart';
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
  Future<void>? _launched;
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
          "Mon tableau de bord",
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
                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => Profil()));
                          },
                          child: Text.rich(
                            TextSpan(
                              style: GoogleFonts.questrial(
                                fontSize: 16.0,
                                fontWeight: FontWeight.w400,
                                color: Color(0xF8F6894D),
                              ),
                              children: [
                                TextSpan(
                                  text: "  " + session.email,
                                )
                              ],
                            ),
                          ),
                        )
                        ,
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
          session.type.toString()=="client" ? GridDashboardClient() :  GridDashboard(),
          SizedBox(height: 10),


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

  Widget layoutForWebSite(){
    return Container(
      margin: EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.orange.withOpacity(.5)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          SizedBox(height: 15),
          Container(
            margin: EdgeInsets.all(5),
            alignment: Alignment.topCenter,
            child: Text(
              "Note d'information",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),

          SizedBox(height: 5),
          Container(
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
            Text(
              "Afin de béneficier de tous les services et fonctionnalitées et un meilleur management de votre compte employeur/client que vous offres NiovarJobs, "
                  "veuillez cliquer sur le  lien ci-dessous afin de vous connectez sur la notre plateforme et accéder a toutes les options qui vous sont offertes.",
              style: GoogleFonts.openSans(
                textStyle: TextStyle(
                  color: Colors.black45,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              textAlign: TextAlign.center,
            ),
          ),


          SizedBox(height: 10),

          Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              color: Colors.orange,
              child: InkWell( onTap: () async {
                _launched = Constante.launchInBrowser("https://niovarjobs.com/Inscrires/Login");
              },
                child: Container(
                  height: 50,
                  width:300,
                  child: Center(
                      child: Text(
                        "Continuer sur NiovarJobs.com",
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white
                        ),
                      ),
                  ),
                ),
                borderRadius: BorderRadius.circular(10),
              )
          ),
          SizedBox(height: 15),
        ],
      ),
    );
  }


}

