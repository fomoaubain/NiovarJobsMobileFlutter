import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/src/CvPage.dart';
import 'package:niovarjobs/src/MesAffectations.dart';
import 'package:niovarjobs/src/MesCandidatures.dart';
import 'package:niovarjobs/src/MesContratTravail.dart';
import 'package:niovarjobs/src/MesLocationsCdt.dart';
import 'package:niovarjobs/src/mesDocuments.dart';
import 'package:niovarjobs/src/mesTalonPaie.dart';

class GridDashboard extends StatelessWidget {


  Items item1 = new Items(
      id:1,
      title: "Mes candidatures",
      subtitle: "Gérer toutes vos \n candidatures",
      event: "",
      img: "assets/candidature.png");

  Items item2 = new Items(
    id:2,
    title: "Mes demandes \n de location",
    subtitle: "Gérer toutes  les demandes \n de location qui vous \n sont adréssées",
    event: "",
    img: "assets/location.png",
  );
  Items item3 = new Items(
    id:3,
    title: "Mon CV",
    subtitle: "Renseigner vos compétences  et diplômes afin d'être vu  par les meilleures recruteurs",
    event: "",
    img: "assets/cv.png",
  );
  Items item4 = new Items(
    id:4,
    title: "Mes documents",
    subtitle: "Sauvegarder vos diplômes, CV et autres documents utiles  à votre profil",
    event: "",
    img: "assets/documents.png",
  );
  Items item5 = new Items(
    id:5,
    title: "Mes affectations",
    subtitle: "Gérer toutes les affectations   qui vous  sont adréssées",
    event: "",
    img: "assets/affectation.png",
  );
  Items item6 = new Items(
    id:6,
    title: "Mes talons de paie",
    subtitle: "Consluter et télécharger   vos talons de paie",
    event: "",
    img: "assets/paie.png",
  );
  Items item7 = new Items(
    id:7,
    title: "Mes contrats \n de travail",
    subtitle: "Consulter et gérer vos \n contrats travail",
    event: "",
    img: "assets/contrat.png",
  );


  @override
  Widget build(BuildContext context) {
    List<Items> myList = [item1, item2, item3, item4, item5, item6, item7];
    var color = 0xff453658;
    return Flexible(
      child: GridView.count(
        childAspectRatio: 1.0,
        padding: EdgeInsets.only(left: 16, right: 16),
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        children: myList.map((data) {
          return  InkWell(
            onTap: () {
              if(data.id==1){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesCandidatures()));
              }
              if(data.id==3){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => CvPage()));
              }

              if(data.id==4){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesDocuments()));
              }
              if(data.id==2){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesLocationsCdt()));
              }

              if(data.id==6){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesTalonPaie()));
              }
              if(data.id==5){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesAffectations()));
              }
              if(data.id==7){
                Navigator.push(
                    context, MaterialPageRoute(builder: (context) => MesContratTravail()));
              }
            },
            child:  Container(
              decoration: BoxDecoration(
                color: Color(0xFFF37B3E),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(data.img, width: 40),
                  SizedBox(height: 5),
                  Container(
                    margin: EdgeInsets.all(5),
                    alignment: Alignment.topCenter,
                    child: Text(
                      data.title,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white,
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
                    child: Text(
                      data.subtitle,
                      style: GoogleFonts.openSans(
                        textStyle: TextStyle(
                          color: Colors.white38,
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 5),
                  Text(
                    data.event,
                    style: GoogleFonts.openSans(
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );

        }).toList(),
      ),
    );
  }
}

class Items {
  int id;
  String title;
  String subtitle;
  String event;
  String img;
  Items({ required this.id, required this.title, required this.subtitle, required this.event, required this.img});
}
