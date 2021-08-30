import 'package:flutter/material.dart';
import 'package:niovarjobs/animation/FadeAnimation.dart';
import 'package:niovarjobs/widget/form_candidat.dart';
import 'package:niovarjobs/widget/form_client.dart';

import '../Constante.dart';
import 'LoginPage.dart';

class CreateUser extends StatefulWidget {

  @override
  _CreateUser createState() => _CreateUser();
}


class _CreateUser extends State<CreateUser> {
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
        centerTitle: true,
      ),
      body: DefaultTabController(
        length: 2,
        child: Container(
          width: double.infinity,
          // margin: EdgeInsets.only(top: 50.0),
          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 15.0),
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
                constraints: BoxConstraints(maxHeight: 150.0),
                child: Column(
                  children: <Widget>[
                    FadeAnimation(1, Text("Créer un compte", style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold
                    ),)),
                    SizedBox(height: 10,),
                    FadeAnimation(1.5, Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("J'ai déjà un compte"),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) => LoginPage()));
                          },
                          child:    Text(" Se connecter", style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15, color: Colors.orange
                          ),),
                        ),

                      ],
                    )),
                    SizedBox(height: 15.0),
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
                          Tab(text: "Candidat"),
                          Tab(text: "Client"),
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
                    form_candidat(),
                    form_client(),
                  ],
                ),
              )
            ],
          ),
        ),
      ),

    );
  }


}