
import 'package:badges/badges.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/model/Postuler.dart';
import 'package:niovarjobs/src/DetailsJob.dart';
import 'package:niovarjobs/src/homePage.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'model/Job.dart';
 class Constante
{
  static String  serveurAdress = "https://www.niovarjobs.com/";
// static String  serveurAdress = "http://192.168.43.63:3000/";
//static String  serveurAdress = "http://192.168.100.110:3000/";
 // static String  serveurAdress = "https://niovar.solutions/";

 static String  token = "LYo32?Z";
 static String  typeClient = "client";
 static String  typeCandidat = "candidat";
  static Future<void>? _launched;


  static const kBlack = Color(0xFF21202A);
  static const kBlackAccent = Color(0xFF3A3A3A);
  static const kSilver = Color(0xFFF6F6F6);
  static const kOrange = Color(0xFFFA5805);
 static const primaryColor=Colors.deepOrange;
 static const secondaryColor=Color(0xffffffff);

  static var  kPageTitleStyle = GoogleFonts.questrial(
    fontSize: 21.0,
    fontWeight: FontWeight.w500,
    color: Color(0xF8F6894D),
    wordSpacing: 2.5,
  );
 static var  kPageTitleStyleCv = GoogleFonts.questrial(
   fontSize: 18.0,
   fontWeight: FontWeight.w500,
   color: Color(0xF8F6894D),
   wordSpacing: 2.5,
 );
  static var  kPageTitleStylefiltre = GoogleFonts.questrial(
    fontSize: 14.0,
    fontWeight: FontWeight.w500,
    color: Colors.black54,
  );
  static var kTitleStyle = GoogleFonts.questrial(
    fontSize: 16.0,
    color: kBlack,
    fontWeight: FontWeight.w400,
  );
  static var kSubtitleStyle = GoogleFonts.questrial(
    fontSize: 14.0,
    color: kBlack,
  );

  static Widget makeJobUgentOrInstantane(Job job){
    String val = '';
    Color colors= Colors.transparent;
    if(job.vedette=="1"){
      val='En vedette';
      colors= Colors.blue.shade400;
    }
    if(job.instantane==1){
      val='Urgente';
      colors= Colors.green.shade400;
    }
    return val.isNotEmpty ? Container(
        height: 18,
        margin: EdgeInsets.symmetric(vertical: 2),
        padding: EdgeInsets.all(2),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: colors
        ),
        child: Text.rich(
          TextSpan(
            style: TextStyle(color: Colors.white, fontSize: 10),
            children: [
              TextSpan(
                text: val,
              ),
            ],
          ),
        )

    ) : SizedBox();
    return Text(val, style: TextStyle(color: colors, fontWeight: FontWeight.bold, fontSize: 12.0));

  }

  static Column circularLoader(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Center(
          child: Container(
            height: 40,
            width: 40,
            margin: EdgeInsets.all(5),
            child: CircularProgressIndicator(
              strokeWidth: 2.0,
              color: Colors.orange[700],

            ),
          ),
        ),
      ],
    );
  }

  static String getSalaire (Job job){
    String val ="";
    if(job.immediat.contains("true")){

  val = job.remuneration_n.toString().isEmpty ? "0 \$ par semaine" : (num.parse(job.remuneration_n) / 2 ).toStringAsFixed(2) + " \$ par semaine";

    }else{
      if(job.negociable.contains("0")){
        val = job.remuneration.toString().isEmpty ? "0 \$ par semaine" : (num.parse(job.remuneration) / 2 ).toStringAsFixed(2) + " \$ par semaine";
      }else if(job.negociable.contains("1")){
        val =" Salaire à négocier";
      }else{
        val =  job.salaireAnnuel.toString().isEmpty ? "0 \$ par année" : (num.parse(job.salaireAnnuel)).toStringAsFixed(2) + " \$ par année";
      }
    }
     return val;
  }


 static String getCompanyName (Postuler postuler){
   String val ="";
   if(postuler.job.immediat.contains("true")){

     val = "NiovarJobs";
   }else{
     val = postuler.inscrire.nom.toString();
   }
   return val;
 }

 static Widget makeInput({label, obscureText = false}) {
   return Column(
     crossAxisAlignment: CrossAxisAlignment.start,
     children: <Widget>[
       Text(label, style: TextStyle(
           fontSize: 15,
           fontWeight: FontWeight.w600,
           color: Colors.black87
       ),),
       SizedBox(height: 5,),
       TextField(
         obscureText: obscureText,
         decoration: InputDecoration(
           contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
           enabledBorder: OutlineInputBorder(
               borderSide: BorderSide(color: Colors.black26)
           ),
           border: OutlineInputBorder(
               borderSide: BorderSide(color: Colors.black26)
           ),
         ),
       ),

     ],
   );
 }

 static Widget makelabel( String label) {
   return  Text(label, style: TextStyle(
       fontSize: 15,
       fontWeight: FontWeight.w600,
       color: Colors.black87
   ),);
 }

 static void showAlert(BuildContext context, String titre, String message, Widget button, double heigthAlertDialog) {
   showDialog(
       context: context,
       builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
           borderRadius:
           BorderRadius.circular(20.0)),
         child: Padding(
           padding: const EdgeInsets.all(12.0),
           child: Container(
             height: heigthAlertDialog,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
               crossAxisAlignment: CrossAxisAlignment.center,
               children: [

                 Text(titre, style: TextStyle( fontWeight: FontWeight.bold, color: Colors.black87),
                 ),
                 SizedBox(height: 10,),
                 Text(message, style: TextStyle( color: Colors.black45),
                 ),
                 SizedBox(height: 10,),
                 button
               ],
             ),
           ),


         ),
       ),
   );
 }

 Widget buttonOfAlertDialog(String name) {
      return  SizedBox(
        width: 320.0,
        child: RaisedButton(
          onPressed: () {},
          child: Text(
            "Save",
            style: TextStyle(color: Colors.white),
          ),
          color: const Color(0xFF1BC0C5),
        ),
      );

 }


 static Text TextwithIcon(IconData icon, String text, Color colors, double textsize){
    return  Text.rich(
      TextSpan(
        style:GoogleFonts.questrial(
          fontSize: textsize,
          color: colors,
          fontWeight: FontWeight.w400,
        ),
        children: [
          WidgetSpan(
            child: Icon(icon,color:Colors.orange, size: 16.0,),
          ),
          TextSpan(
            text: text,
          )
        ],
      ),
    );
  }

  static const style4=TextStyle(
    color: Colors.black,
    fontSize: 15,
    fontWeight: FontWeight.bold,
  );
  static const style5=TextStyle(
    color: Colors.black,
    fontSize: 10,
  );
  static  const style6=TextStyle(
    color: Colors.black,
    fontSize: 10,
    fontWeight: FontWeight.bold,
  );

 static const style7=TextStyle(
   color: Colors.black,
   fontSize: 14,
   fontWeight: FontWeight.bold,
 );

 static const style8=TextStyle(
   color: Colors.black45,
   fontSize: 12,
   fontWeight: FontWeight.bold,
 );


  static  Widget Input(hintText,TextEditingController controller){
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: hintText,
          hintStyle: style5,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack.withOpacity(0.3)),
          )
      ),
      style: style5,
    );
  }

  static Widget Input1(hintText,TextEditingController controller){
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      maxLines: 7,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: hintText,
          hintStyle: style5,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack.withOpacity(0.3)),
          )
      ),
      style: style5,
    );
  }

  static Widget Input2(bool obscuretext, hintText,TextEditingController controller){
    return TextField(
      controller: controller,
      cursorColor: Colors.black,
      obscureText: obscuretext,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          hintText: hintText,
          hintStyle: style6,
          border: InputBorder.none,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: kBlack.withOpacity(0.3)),
          )
      ),
      style: style4,
    );
  }

 static Widget ShimmerVertical(int itemNumber){
   return Shimmer.fromColors(
       child: ListView.builder(
           itemCount: itemNumber,
           scrollDirection: Axis.vertical,
           shrinkWrap: true,
           physics: ScrollPhysics(),
           itemBuilder: (context,i){
             return ListTile(
               leading: Icon(Icons.image, size: 50,),
               title: SizedBox(
                 height: 40,
                 child: Container(
                   color: Colors.grey,

                 ),
               ),
             );
           }
       ),
     baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
   );
 }

 static Widget ShimmerHorizontal(int itemNumber){
   return Shimmer.fromColors(
     child: ListView.builder(
         itemCount: itemNumber,
         scrollDirection: Axis.horizontal,
         shrinkWrap: true,
         physics: BouncingScrollPhysics(),
         itemBuilder: (context,i){
           return Card(
             elevation: 1.0,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(16),
             ),
             child: const SizedBox(height: 20, width: 150,),
           );
         }
     ),
     baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
   );
 }


 static Widget ShimmerSimpleVertical(int itemNumber){
   return Shimmer.fromColors(
     child: ListView.builder(
         itemCount: itemNumber,
         scrollDirection: Axis.vertical,
         shrinkWrap: true,
         physics: ScrollPhysics(),
         itemBuilder: (context,i){
           return Card(
             elevation: 1.0,
             shape: RoundedRectangleBorder(
               borderRadius: BorderRadius.circular(16),
             ),
             child: const SizedBox(height: 50),
           );
         }
     ),
     baseColor: Colors.grey[300]!,
     highlightColor: Colors.grey[100]!,
   );
 }

  //create this function, so that, you needn't to configure toast every time
static  void showToastMessage(String message){
    Fluttertoast.showToast(
        msg: message, //message to show toast
        toastLength: Toast.LENGTH_LONG, //duration for message to show
        gravity: ToastGravity.CENTER, //where you want to show, top, bottom
        timeInSecForIosWeb: 1, //for iOS only
        //backgroundColor: Colors.red, //background Color for message
        textColor: Colors.white, //message text color
        fontSize: 16.0 //message font size
    );
  }

  static showToastSuccess(String msg, FToast float) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.green,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.check, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 12),),
        ],
      ),
    );

    float.showToast(
      child: toast,
      gravity: ToastGravity.TOP,
      toastDuration: Duration(seconds: 3),
    );

  }

  static showToastError(String msg, FToast float) {
    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Colors.black,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error, color: Colors.white,),
          SizedBox(
            width: 12.0,
          ),
          Text(msg, style: TextStyle(color: Colors.white, fontSize: 12),),
        ],
      ),
    );

    float.showToast(
      child: toast,
      gravity: ToastGravity.BOTTOM,
      toastDuration: Duration(seconds: 2),
    );

  }

 static  Widget layoutNotInternet( BuildContext context, Route route){
   return Container(
     width: 300,
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         SizedBox(height: 15),
         Container(
           margin: EdgeInsets.all(5),
           alignment: Alignment.topCenter,
           child: Text(
             "Aucune connexion internet ! ",
             style: GoogleFonts.openSans(
               textStyle: TextStyle(
                 color: Colors.black45,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ),

         SizedBox(height: 2),
         Container(
           alignment: Alignment.center,
           padding: EdgeInsets.symmetric(horizontal: 10),
           child:
           Text(
             "Aucune connexion internet disponible ! Vérifier votre point d'accès ou réessayer.",
             style: GoogleFonts.openSans(
               textStyle: TextStyle(
                 color: Colors.black45,
                 fontSize: 9,
                 fontWeight: FontWeight.w600,
               ),
             ),
             textAlign: TextAlign.center,
           ),
         ),
         SizedBox(height: 10),
         InkWell(
             onTap: ()  {
               Navigator.pop(context);
               Navigator.push(context, route);
             },
           child: Icon(Icons.refresh, size: 40, color: Colors.grey,)
         ),
         SizedBox(height: 15),
       ],
     ),
   );
 }

 static  Widget layoutDataNotFound( String text){
   return Container(
     width: 300,
     child: Column(
       mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         SizedBox(height: 15),
         Container(
           margin: EdgeInsets.all(5),
           alignment: Alignment.topCenter,
           child: Text(
             text,
             style: GoogleFonts.openSans(
               textStyle: TextStyle(
                 color: Colors.black45,
                 fontSize: 16,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ),
         ),
       ],
     ),
   );
 }

 static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: true,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  static void showSnackBarMessage(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
         SnackBar(
          content:Text(text),
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
        )
    );

  }


  static void showAlertRedirectWebSite(BuildContext context, String url) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
            borderRadius:
            BorderRadius.circular(20.0)),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Container(
            height: 300,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.orange.withOpacity(.5)),
              borderRadius: BorderRadius.circular(10),
            ),
            child: SingleChildScrollView(
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
                        _launched = launchInBrowser(url);
                      },
                        child: Container(
                          margin: EdgeInsets.all(5),
                          height: 50,
                          width:300,
                          child: Center(
                            child: Text(
                              "Continuer sur NiovarJobs.com",
                              style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  fontSize: 16,
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
            ),

          ),




        ),
      ),
    );
  }

 static  Future<bool?> AlertInternetNotFound( BuildContext context){
    return Alert(
      context: context,
      type: AlertType.error,
      title: "Oups !",
      desc: "Problème de connexion au serveur. Veuillez verifier votre connexion internet",
      buttons: [
        DialogButton(
            child: Text(
              "fermer",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120
        )
      ],
    ).show();
 }

 static  Future<bool?> AlertMessageFromRequest( BuildContext context, String message){
   return Alert(
     context: context,
     type: AlertType.warning,
     desc: message,
     buttons: [
       DialogButton(
           child: Text(
             "fermer",
             style: TextStyle(color: Colors.white, fontSize: 20),
           ),
           onPressed: () => Navigator.pop(context),
           width: 120
       )
     ],
   ).show();
 }

  static  Future<bool?> AlertLoadingWithMessage( BuildContext context){
    return Alert(
      context: context,
      type: AlertType.none,
      desc: "Veuillez patientez...",
      buttons: [
        DialogButton(
          color: Colors.white,
          child: SizedBox(
            height: 35,
            width: 35,
            child: CircularProgressIndicator(
              color: Colors.orange,
              strokeWidth: 1.5,
            ),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],

    ).show();
  }

 static ListTile makeListTileJob(BuildContext context, Postuler postuler) => ListTile(
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
                 Constante.makeJobUgentOrInstantane(postuler.job),
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

 }



