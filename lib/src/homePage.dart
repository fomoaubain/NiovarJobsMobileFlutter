import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Job.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/AbonnementPage.dart';
import 'package:niovarjobs/src/DetailsJob.dart';
import 'package:niovarjobs/src/FaqPage.dart';
import 'package:niovarjobs/src/ListCompagnie.dart';
import 'package:niovarjobs/src/ListJob.dart';
import 'package:niovarjobs/src/PageCompagny.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:niovarjobs/src/LoginPage.dart';
import 'package:niovarjobs/src/ResultatPage.dart';
import 'package:niovarjobs/src/filterPage.dart';
import 'package:niovarjobs/src/notificationPage.dart';
import 'package:niovarjobs/src/profil.dart';
import 'package:niovarjobs/src/upload_cv.dart';
import 'package:niovarjobs/widget/company_card.dart';
import 'package:niovarjobs/widget/company_card2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niovarjobs/Global.dart' as session;
import 'Dashbord.dart';
import 'drawer/drawer_header.dart';
import 'package:http/http.dart' as http;
import 'package:badges/badges.dart';

class homePage extends StatefulWidget {
  homePage({ Key? key,  required this.title}) : super(key: key);

  final String title;

  @override
  _homePageState createState() => _homePageState();

}

class _homePageState extends  State<homePage> with SingleTickerProviderStateMixin{
  late TabController _controller;

  late Future<List<Postuler>>  listOffreVedette;
  late Future<List<Postuler>>  listOffreRecent;
  late Future<List<Inscrire>>  listCompagnie;
  var loading = false;
  late List<Postuler> objJob=[], objJob2=[], initListJob=[], initListJob2=[];
  late List<Inscrire> initListInscrire=[], objInscrire=[];
  var currentPage = DrawerSections.home;
  int _currentMax=4;
  late var nbreNotif=0;

  bool isLoggedIn = false;

  ScrollController _scrollController = new ScrollController();
  ScrollController _scrollController2 = new ScrollController();
  ScrollController _scrollController3 = new ScrollController();

  final TextEditingController libelle = TextEditingController();


  Future<List<Postuler>> fetchItem(String urlApi, int val) async {
    List<Postuler> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Postuler.fromJson(element));
        });
      }
    }
    if(val == 1){
      initListJob=  listModel.take(6).toList();
    }
    if(val == 2){
      initListJob2=  listModel.take(6).toList();
    }

    return listModel.take(10).toList();
  }

  Future GetNbreNotification() async {
    final response = await http.get(Uri.parse(Constante.serveurAdress+"RestUser/NbreNotifications/"+session.id));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['count'];
      if (data != null) {
        setState(() {
          nbreNotif = data;

        });
      }
    }
  }



  Future<List<Inscrire>> fetchItemInscire(String urlApi) async {
    List<Inscrire> listModel = [];
    final response = await http.get(Uri.parse(Constante.serveurAdress+urlApi));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body)['datas'];
      if (data != null) {
        data.forEach((element) {
          listModel.add(Inscrire.fromJson(element));
        });
      }
    }

    initListInscrire = listModel;
    return listModel.take(6).toList();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return  Scaffold(
      backgroundColor: Constante.kSilver,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black87, //change your color here
        ),
        backgroundColor: Constante.kSilver,
        elevation: 0.0,
        leading: Padding(
          padding: const EdgeInsets.only(
            left: 18.0,
            top: 12.0,
            bottom: 12.0,
            right: 12.0,
          ),
          child: InkWell(
            onTap: () {
              if(!isLoggedIn){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => FaqPage()));
              }else{
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Dashbord()));
              }

            },
            child: SvgPicture.asset(
              "assets/drawer.svg",
              color: Constante.kBlack,
            ),
          ),

        ),
        actions: <Widget>[
         !isLoggedIn ? profilLogout() : profilLogin(),
          SizedBox(width: 8.0),
          !isLoggedIn ? SizedBox(width: 0.0) : ShowBadge(),
          SizedBox(width: 5.0),
          !isLoggedIn ? SizedBox(width: 0.0) : ShowPupopMenu(),

        ],
      ),
      body: Container(
        margin: EdgeInsets.only(left: 18.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 25.0),
              Text(
                    "Travaillez autrement,\n vivez mieux !",
                style: Constante.kPageTitleStyle,
              ),
              SizedBox(height: 25.0),
              Container(
                width: double.infinity,
                height: 50.0,
                margin: EdgeInsets.only(right: 18.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: TextFormField(
                          cursorColor: Constante.kBlack,
                          decoration: InputDecoration(
                            icon: Icon(
                              Icons.search,
                              size: 25.0,
                              color: Constante.kBlack,
                            ),
                            border: InputBorder.none,
                            hintText: "Saisir un mot clé",
                            hintStyle: Constante.kSubtitleStyle.copyWith(
                              color: Colors.black38,
                            ),
                          ),
                          controller: libelle,
                          onFieldSubmitted: (libelle) {
                            print(this.libelle.text);
                            if(!this.libelle.text.isEmpty){
                              Navigator.push(
                                  context, MaterialPageRoute(builder: (context) => ResultatPage(titre: this.libelle.text)));
                            }
                          },
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => FilterPage()));
                      },
                      child: Container(
                        width: 50.0,
                        height: 50.0,
                        margin: EdgeInsets.only(left: 12.0),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Icon(
                          FontAwesomeIcons.slidersH,
                          color: Colors.white,
                          size: 20.0,
                        ),
                      ),
                    ),


                  ],
                ),
              ),
              SizedBox(height: 35.0),
              Row(
                children: [
                  Expanded(child:
                  Text(
                    "Compagnies recommandees",
                    style: Constante.kTitleStyle,
                  ),
                  ),
                  Container(
                      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ListCompagnie()));
                        },
                        child: Text(
                          "Voir plus",
                          style: Constante.kTitleStyle,
                        ),
                      )
                  ),

                ],
              ),

              SizedBox(height: 15.0),
              Container(
                width: double.infinity,
                height: 190.0,
                child:FutureBuilder<List<Inscrire>>(
                  future: listCompagnie,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState != ConnectionState.done) {
                      return Constante.circularLoader();

                    }
                    if(snapshot.hasError) {
                      return Center(
                          child: Text("Aucune connexion disponible", style: TextStyle(color:  Color(0xFFFA5805), fontSize: 16.0))
                      );
                    }
                    if(initListInscrire.length==0) {
                      return Center(
                          child: Text("Aucune compagnie disponible", style: TextStyle(color: Colors.orange, fontSize: 16.0))
                      );
                    }
                    if(snapshot.hasData) {
                      if(objInscrire.length==0){
                        objInscrire = snapshot.data ?? [];
                      }else{
                        objInscrire = objInscrire.toList();
                      }

                      return ListView.builder(
                          controller: _scrollController3,
                          itemCount: loading ? objInscrire.length + 1 : objInscrire.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context,i){
                            if (objInscrire.length == i){
                              return Center(
                                  child: CupertinoActivityIndicator()
                              );
                            }
                            Inscrire nDataList = objInscrire[i];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => PageCompagny( idPage: nDataList.id,)
                                  ),

                                );
                              },
                              child: i == 0
                                  ? CompanyCard(company: nDataList)
                                  : CompanyCard2(company: nDataList),
                            );
                          }
                      );
                    }
                    // By default, show a loading spinner.
                    return Constante.circularLoader();
                  },
                ),
              ),
              SizedBox(height: 35.0),

              Row(
                children: [
                  Expanded(child:
                  Text(
                    "Offres récentes",
                    style: Constante.kTitleStyle,
                  ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => ListJob()));
                      },
                      child: Text(
                        "Voir plus",
                        style: Constante.kTitleStyle,
                      ),
                    )
                  ),

                ],
              ),
              SizedBox(height: 15.0),

              Container(
                child:FutureBuilder<List<Postuler>>(
                  future: listOffreRecent,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState != ConnectionState.done) {
                      return Constante.circularLoader();

                    }
                    if(snapshot.hasError) {
                      return Center(
                          child: Text("Aucune connexion disponible", style: TextStyle(color: Colors.redAccent, fontSize: 16.0))
                      );
                    }
                    if(initListJob.length==0) {
                      return Center(
                          child: Text("Aucune offre d'emploi disponible", style: TextStyle(color: Colors.orange, fontSize: 16.0))
                      );
                    }
                    if(snapshot.hasData) {
                      if(objJob.length==0){
                        objJob = snapshot.data ?? [];
                      }else{
                        objJob = objJob.toList();
                      }
                      return ListView.builder(
                          controller: _scrollController,
                          itemCount: loading ? objJob.length + 1 : objJob.length,
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context,i){

                            if (objJob.length == i){
                              return Center(
                                  child: CupertinoActivityIndicator()
                              );
                            }
                            Postuler nDataList = objJob[i];
                            return Container(
                              child: Card(
                                elevation: 0.0,
                                margin: new EdgeInsets.symmetric(horizontal: 4.0, vertical: 6.0),
                                child: Container(
                                  decoration: BoxDecoration(color: Colors.white,
                                      border: new Border(
                                          right: new BorderSide(width: 1.0, color: Colors.white24),
                                      )
                                  ),
                                  child: makeListTile(nDataList),
                                ),
                              ),
                            );
                          }
                      );
                    }
                    // By default, show a loading spinner.
                    return Container(
                      padding: EdgeInsets.only(top: 20.0),
                      child: Constante.circularLoader(),
                    );

                  },
                ),
              ),


            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        onPressed: () async {
          if(!session.IsConnected){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => LoginPage()));
            return;
          }else{
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => UploadCv()));
          }

        },
        child: Icon(Icons.note_add),
      ),
    );
  }

  Widget MyDrawerList(){
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1,'Accueil',Icons.home, currentPage==DrawerSections.home ? true :false),
          menuItem(2,'Mes abonnements',Icons.monetization_on_sharp, currentPage==DrawerSections.abonnements ? true :false),
          Divider(),
          menuItem(3,'Comment sa marche',Icons.help, currentPage==DrawerSections.faqPage ? true :false),
          menuItem(4,'Contact',Icons.phone, currentPage==DrawerSections.contact ? true :false),
          Divider(),
          menuItem(5,'Se connecter',Icons.login, currentPage==DrawerSections.logIn ? true :false),
          menuItem(6,'Se deconnecter',Icons.logout, currentPage==DrawerSections.logOut ? true :false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected){
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if(id==1){ currentPage=DrawerSections.home; }
            else if(id==2){ currentPage=DrawerSections.abonnements;
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => homePage(title: "title")));
            }
            else if(id==3){ currentPage=DrawerSections.faqPage; }
            else if(id==4){ currentPage=DrawerSections.contact; }
            else if(id==5){ currentPage=DrawerSections.logIn; }
            else if(id==6){ currentPage=DrawerSections.logOut; }

          });
        },
        child:  Padding(
          padding:  EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(child: Icon(icon, size: 20,color: Colors.black,)),
              Expanded(flex: 3, child: Text(title,  style: TextStyle(color: Colors.black, fontSize: 16), ))
            ],
          ),
        ),

      ),
    );
  }

  Widget menuTabItem(int id, String title, IconData icon){
    return Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: 16,
            color: Colors.black87
        ),
        children: [
          WidgetSpan(
            child: Icon(icon,color:Colors.black87 , ),
          ),
          TextSpan(
            text: title,
          )
        ],
      ),
    );
  }

  Widget profilLogout(){
    return  InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 6),
          child:
          SvgPicture.asset("assets/user.svg",
            width: 25.0,
            color: Constante.kBlack,
          ),
        ),

    );
  }

  Widget ShowPupopMenu(){
    return  PopupMenuButton(
      itemBuilder: (BuildContext bc) => [
        PopupMenuItem(child: Constante.TextwithIcon(Icons.dashboard_outlined, " Mon panel", Colors.black87, 15), value: 1),
        PopupMenuItem(
            child: Constante.TextwithIcon(Icons.lock_open_rounded, "Se deconnecter", Colors.black87, 15), value: 2),
      ],
      onSelected: (value) async {
       if(value==1){
         Navigator.push(
             context, MaterialPageRoute(builder: (context) => Dashbord()));
       } else if(value==2){
         final SharedPreferences prefs = await SharedPreferences.getInstance();
         prefs.clear();
         session.IsConnected=false;
         Navigator.pushAndRemoveUntil(
             context,
             MaterialPageRoute(
                 builder: (context) => homePage(title: "",)
             ),
             ModalRoute.withName("/Home")
         );
       }
      },
    );
  }
  Widget ShowBadge(){
    return   Container(
      margin: EdgeInsets.only(top: 5),
      child: InkWell(
        onTap:  () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => NotificationPage()));
        },
        child: Badge(
          badgeContent: Text(nbreNotif.toString(), style: TextStyle(color: Colors.white),),
          badgeColor: Colors.green,
          child: Icon(Icons.notifications, size: 25,),
        ),
      )


    );

  }
  Widget profilLogin(){
    return  InkWell(
      onTap: () {
        if(!isLoggedIn){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => LoginPage()));
        }else{
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => Profil()));
        }
      },
      child:Container(
        margin: EdgeInsets.only(top: 10),
        height: 50,
        width: 50,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 35,
              width: 40,
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
                )
            ),
           ],
        ),

      ),
    );


  }

   ListTile makeListTile(Postuler postuler) => ListTile(
    contentPadding:
    EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
    leading: Container(
      decoration: new BoxDecoration(
          border: new Border(
              right: new BorderSide(width: 1.0, color: Colors.white24))),
      child: Card(
        child: CachedNetworkImage(

          width: 60.0,
          imageUrl: Constante.serveurAdress+postuler.inscrire.profilName,
          placeholder: (context, url) => CupertinoActivityIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      ),
    ),
    title: Text(
      postuler.job.titre,
      style: TextStyle(color: Colors.orange[700], fontWeight: FontWeight.bold, fontSize: 16.0),
    ),
    subtitle: Row(
      children: <Widget>[
        Expanded(
            flex: 12,
            child: Container(
              child : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 14,
                          color: Colors.black54,
                        fontWeight: FontWeight.bold
                      ),
                      children: [

                        TextSpan(
                          text: Constante.getSalaire(postuler.job),
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.location_on,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: postuler.job.pays+", "+ postuler.job.province +", "+postuler.job.ville,
                        )
                      ],
                    ),
                  ),
                  Text.rich(
                    TextSpan(
                      style: TextStyle(
                          fontSize: 10,
                          color: Colors.black54
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.calendar_today,color:Colors.black45, size: 14.0,),
                        ),
                        TextSpan(
                          text: "Publié le : "+postuler.job.created,
                        )
                      ],
                    ),
                  ),

                 Constante.makeVedette(postuler.job),
                ],
              ),

            )),


      ],
    ),
    trailing:
    Icon(Icons.keyboard_arrow_right, color: Colors.orange[700], size: 30.0),
    onTap: () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => DetailsJob( idJob: postuler.job.id,forVisit: false,)));
    },
  );

  @override
  void initState() {
    super.initState();
    _controller = TabController(vsync: this, length: 3);

    checkUserConnect();

    listOffreVedette= this.fetchItem('RestJob/listoffrevedette',2);

    listOffreRecent= this.fetchItem('RestJob/listoffrerecent?token='+Constante.token,1);

    listCompagnie= this.fetchItemInscire('RestJob/listcompagnie?token='+Constante.token);
    _scrollController.addListener(_onScroll);
    _scrollController2.addListener(_onScroll2);
    _scrollController3.addListener(_onScroll3);
  }


  void checkUserConnect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    session.email = prefs.getString('email')!;
    session.profil  = prefs.getString('profil')!;
    session.login  = prefs.getString('login')!;
    session.id  = prefs.getString('id')!;
    session.type  = prefs.getString('type')!;

    if(session.id.isNotEmpty){
      GetNbreNotification();
    }
    
    setState(() {
      if(!session.id.isEmpty){
        isLoggedIn = true;
        session.IsConnected=true;
      }
    });

  }

  _onScroll(){
    if (_scrollController.offset >=
        _scrollController.position.maxScrollExtent &&
        !_scrollController.position.outOfRange) {
      setState(() {
        loading = true;
      });
      _fetchData();
    }

  }

  _onScroll2(){
    if (_scrollController2.offset >=
        _scrollController2.position.maxScrollExtent &&
        !_scrollController2.position.outOfRange) {
      setState(() {
        loading = true;
      });
      _fetchData2();
    }

  }
  _onScroll3(){
    if (_scrollController3.offset >=
        _scrollController3.position.maxScrollExtent &&
        !_scrollController3.position.outOfRange) {
      setState(() {
        loading = true;
      });
      _fetchData3();
    }

  }
  Future _fetchData() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      objJob = initListJob.take(objJob.length+6).toList();
      loading = false;
    });
  }

  Future _fetchData2() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      objJob2 = initListJob2.take(objJob2.length+6).toList();
      loading = false;
    });
  }

  Future _fetchData3() async {
    await new Future.delayed(new Duration(seconds: 2));
    setState(() {
      objInscrire = initListInscrire.take(objInscrire.length+6).toList();
      loading = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    _scrollController2.dispose();
    _scrollController3.dispose();
    super.dispose();
  }
}


enum DrawerSections{
  home,
  faqPage,
  contact,
  logIn,
  logOut,
  abonnements
}





