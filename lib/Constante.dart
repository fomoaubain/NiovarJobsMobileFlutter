
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/model/Postuler.dart';

import 'model/Job.dart';
 class Constante
{
 // static String  serveurAdress = "https://www.niovarjobs.com/";
  static String  serveurAdress = "http://192.168.43.63:3000/";
// static String  serveurAdress = "http://192.168.0.102:3000/";

 static String  token = "LYo32?Z";
 static String  typeClient = "client";
 static String  typeCandidat = "candidat";

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

  static Text makeVedette(Job job){
    String val = '';
    if(job.vedette.contains("1")){
      val='En vedette';
    }
    return Text(val, style: TextStyle(color: Colors.green[300], fontWeight: FontWeight.bold, fontSize: 12.0));
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
 }

