import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:google_fonts/google_fonts.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Inscrire.dart';
import 'package:niovarjobs/model/Job.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/services/LocalNotificationService.dart';
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
import 'package:niovarjobs/src/ShimmerEffectState.dart';
import 'package:niovarjobs/src/filterPage.dart';
import 'package:niovarjobs/src/notificationPage.dart';
import 'package:niovarjobs/src/profil.dart';
import 'package:niovarjobs/src/upload_cv.dart';
import 'package:niovarjobs/widget/company_card.dart';
import 'package:niovarjobs/widget/company_card2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:niovarjobs/Global.dart' as session;
import 'package:shimmer/shimmer.dart';
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

/*Future<String> testToken() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.containsKey('token') ? prefs.getString('token') : "";
  print("test token "+token.toString());
  final response = await http.post(Uri.parse(Constante.serveurAdress+"Api/test1"),
      headers: {
    "Authorization": "Bearer $token"
      }
  );
  if (response.statusCode == 200) {
    final data =response.body;
    print("Authorization " +data.toString());
    return data;
  }
  return "";
}

Future<String> testToken2() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  var token = prefs.containsKey('token') ? prefs.getString('token') : "";
  print("test token "+token.toString());
  final response = await http.post(Uri.parse(Constante.serveurAdress+"Api/test2"),
      headers: {
        "Authorization": "Bearer $token"
      });
  if (response.statusCode == 200) {
    final data =response.body;
    print("Authorization " +data.toString());
    return data;
  }
  return "";
}*/

class _homePageState extends  State<homePage> with SingleTickerProviderStateMixin{
  late FToast fToast;
  late TabController _controller;
  late final FirebaseMessaging _messaging;
  Future<void>? _launched;

  bool showSectionCompagnie= true;

  late Future<List<Postuler>>  listOffreVedette;
  late Future<List<Postuler>>  listOffreRecent;
  late Future<List<Inscrire>>  listCompagnie;
  var loading = false;
  late List<Postuler> objJob=[], objJob2=[], initListJob=[], initListJob2=[];
  late List<Inscrire> initListInscrire=[], objInscrire=[];
  var currentPage = DrawerSections.home;
  int _currentMax=4;

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
          session.nbreNotif = data;
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
    if(initListInscrire.length==0) {
      setState(() {
        showSectionCompagnie=false;
      });
    }
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
              if (showSectionCompagnie) ...[
               SizedBox(height: 35.0),
               Row(
                  children: [
                    Expanded(child:
                    Text(
                      "Compagnies recommandées",
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
              ],

              Container(
                width: double.infinity,
                height: showSectionCompagnie ? 190.0 : 0.0,
                child:FutureBuilder<List<Inscrire>>(
                  future: listCompagnie,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState != ConnectionState.done) {
                      return Constante.ShimmerHorizontal(6);
                    }
                    if(snapshot.hasError) {
                      return Center(
                          child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => homePage(title: "")) )
                      );
                    }
                    if(initListInscrire.length==0) {
                      return SizedBox();
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
                                    builder: (context) => PageCompagny( nDataList.id,)
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
                    return  Constante.ShimmerHorizontal(6);
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
                      return Constante.ShimmerVertical(10);

                    }
                    if(snapshot.hasError) {
                      return Center(
                          child: Constante.layoutNotInternet(context, MaterialPageRoute(builder: (context) => homePage(title: "")))
                      );
                    }
                    if(initListJob.length==0) {
                      return Center(
                          child: Constante.layoutDataNotFound("Aucune offre d'emploi disponible")
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
                                  child: Constante.makeListTileJob(context, nDataList),
                                ),
                              ),
                            );
                          }
                      );
                    }
                    // By default, show a loading spinner.
                    return Constante.ShimmerVertical(10);

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
            if(session.type.isNotEmpty && session.type=="client"){
              showAlertPopupMenu(context);
            }else{
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => UploadCv()));
            }
          }
        },
        child: session.type.isNotEmpty && session.type=="client" ? Icon(Icons.post_add) : Icon(Icons.note_add),
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
        PopupMenuItem(child: Constante.TextwithIcon(Icons.dashboard_outlined, " Mon tableau de bord", Colors.black87, 15), value: 1),
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
           Navigator.of(context)
               .push(MaterialPageRoute(
             builder: (context) => NotificationPage(),
           ))
               .then((value) {
             // you can do what you need here
             setState(() {
               session.nbreNotif= session.nbreNotif;
             });

           });
        },
        child: Badge(
          badgeContent: Text(session.nbreNotif.toString(), style: TextStyle(color: Colors.white),),
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



  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast.init(context);
    _controller = TabController(vsync: this, length: 3);

    loadFirebaseNotification();
    checkUserConnect();


    listOffreVedette= this.fetchItem('RestJob/listoffrevedette',2);

    listOffreRecent= this.fetchItem('RestJob/listoffrerecent?token='+Constante.token,1);

    listCompagnie= this.fetchItemInscire('RestJob/listcompagnie?token='+Constante.token);
    _scrollController.addListener(_onScroll);
    _scrollController2.addListener(_onScroll2);
    _scrollController3.addListener(_onScroll3);

  }

 void loadFirebaseNotification() async {
    FirebaseMessaging.instance.getInitialMessage().then((message){
      if(message!.notification!=null){
        setState(() {
          if(message.data["type"].toString().contains("single") ){
            session.nbreNotif=session.nbreNotif+1;
          }
        });
        if(message.data["id"].toString().isNotEmpty ){
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => DetailsJob(idJob: message.data["id"].toString(),forVisit: false,)));
        }else{
          Navigator.pushNamed(context, "/notification");
        }
      }
    });
    _messaging = FirebaseMessaging.instance;
    _messaging.subscribeToTopic('all');

    /*final String? token = await _messaging.getToken();
    if(token!.isNotEmpty){
     session.fcmToken=token;
    }
    print("Token : "+ token.toString());*/

    // 3. On iOS, this helps to take the user permissions
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      // For handling the received notifications
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Parse the message received
        if(message.notification!=null){

          setState(() {
            if(message.data["type"].toString().contains("single") ){
              session.nbreNotif=session.nbreNotif+1;
            }
          });

          print("premier plan "+message.notification!.body.toString());
          print("premier plan "+message.notification!.title.toString());
        }

        LocalNotificationService.display(message);
      });

      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print("route  ok pour onMessageOpenApp");
        if(message.notification!=null){
          setState(() {
            if(message.data["type"].toString().contains("single") ){
              session.nbreNotif=session.nbreNotif+1;
            }
          });
            if(message.data["id"].toString().isNotEmpty ){
              session.nbreNotif=session.nbreNotif+1;
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => DetailsJob(idJob: message.data["id"].toString(),forVisit: false,)));
            }else{
              Navigator.pushNamed(context, "/notification");
            }
        }
      });
    } else {
      print('User declined or has not accepted permission');
    }
  }


  void checkUserConnect() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    session.email = prefs.getString('email')!;
    session.profil  = prefs.getString('profil')!;
    session.login  = prefs.getString('login')!;
    session.id  = prefs.getString('id')!;
    session.type  = prefs.getString('type')!;
    session.token  = prefs.getString('token')!;

    setState(() {
      if(!session.id.isEmpty){
        isLoggedIn = true;
        session.IsConnected=true;
      }
    });

    if(session.id.isNotEmpty){
      String topic="user"+session.id.toString();
      _messaging.subscribeToTopic(topic.toString());
      GetNbreNotification();
    }
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

 void showAlertPopupMenu(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container (
            height: 500,
            child: SingleChildScrollView(

              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Text("Main d'oeuvre", style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  Divider(),
                  AlertMenuItem("Demander main d'oeuvre", Icons.add,
                  ),
                  Divider(),
                  AlertMenuItem("Publier une offre d'emploi", Icons.add,
                  ),
                  Divider(),
                  AlertMenuItem("Louer un employé", Icons.add,
                  ),
                  Divider(),
                  AlertMenuItem("Banque de CV", Icons.add,
                  ),
                  Divider(),
                  AlertMenuItem("Mettre une offre d'emploi en vedette", Icons.add,
                  ),
                  Divider(),
                  AlertMenuItem("Devenir une entreprise recommandée", Icons.add,
                  ),
                  Divider(),

                  SizedBox(height: 10,),

                ],
              ),
            ),
          ),




        ),
      ),
    );
  }

  Widget AlertMenuItem(String title, IconData icon) {

    return ListTile(
      title: Text(title,  style: TextStyle(fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black54),
      ),
      trailing:
      Icon(Icons.keyboard_arrow_right, color: Colors.black45, size: 30.0),
      onTap: () async {
        Navigator.pop(context);
        Constante.showAlertRedirectWebSite(context, "https://niovarjobs.com/Inscrires/Login");
      },
    );

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





