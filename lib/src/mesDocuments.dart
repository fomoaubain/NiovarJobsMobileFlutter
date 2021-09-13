import 'dart:async';
import 'dart:io';

import 'package:niovarjobs/src/ListDocument.dart';
import 'package:niovarjobs/widget/AddDocument.dart';
import 'package:niovarjobs/widget/AddEducation.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class MesDocuments extends StatefulWidget {
  @override
  _MesDocuments createState() => _MesDocuments();
}

class _MesDocuments extends State<MesDocuments> {


  @override
  void initState() {
    super.initState();

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
          "Mes documents",
          style: Constante.kTitleStyle,
        ),
        centerTitle: true,
      ),

      body:Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child:Text(
                    'Liste de mes documents :',
                    style: Constante.style4,
                  ), ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                        elevation: 8,
                        child: InkWell( onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ListDocument("cv")));
                        },
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.folder,color: Constante.primaryColor,size: 50,),
                                    Text(
                                      'CV',
                                      style: Constante.style4,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      )),
                  Expanded(
                      child: Card(
                        elevation: 8,
                        child: InkWell( onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ListDocument("diplome")));
                        },
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.folder,color: Colors.blue,size: 50,),
                                    Text(
                                      'Diplomes',
                                      style: Constante.style4,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Expanded(
                      child: Card(
                        elevation: 8,
                        child: InkWell( onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ListDocument("autre")));
                        },
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.folder,color: Colors.pink,size: 50,),
                                    Text(
                                      'Autre document',
                                      style: Constante.style4,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      )),
                  Expanded(
                      child: Card(
                        elevation: 8,
                        child: InkWell( onTap: (){
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => AddDocument()));
                        },
                          child: Container(
                            width: double.infinity,
                            height: 140,
                            child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.note_add_rounded,color: Colors.green,size: 50,),
                                    Text(
                                      ' Ajouter un \n document',
                                      style: Constante.style4,
                                    ),
                                  ],
                                )),
                          ),
                        ),
                      )),
                ],
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => AddDocument()));
        },
        child: Icon(Icons.note_add_rounded),
      ),
    );

  }
}