import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/src/CvPage.dart';
import 'package:niovarjobs/src/MesAffectations.dart';
import 'package:niovarjobs/src/MesCandidatures.dart';
import 'package:niovarjobs/src/MesContratTravail.dart';
import 'package:niovarjobs/src/MesLocationsCdt.dart';
import 'package:niovarjobs/src/mesDocuments.dart';
import 'package:niovarjobs/src/mesTalonPaie.dart';

import '../Constante.dart';

class GridDashboardClient extends StatelessWidget {

  Future<void>? _launched;
  Items item1 = new Items(
      id:1,
      title: "Page entreprise",
      subtitle: "Administer la page de   \n votre enptreprise",
      event: "",
      img: "assets/page.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );

  Items item2 = new Items(
    id:2,
    title: "Gérer mes offres \n d'emploi",
    subtitle: "Gérer toutes vos offres\n  et les candidatures ",
    event: "",
    img: "assets/location.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item3 = new Items(
    id:3,
    title: "Mes demandes de \nmain d'oeuvre",
    subtitle: "Gérer mes demandes et\nles candidatures qui \nvous  sont deposés",
    event: "",
    img: "assets/oeuvre.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item4 = new Items(
    id:4,
    title: " Mes demandes \n   locations",
    subtitle: "Gérer toutes locations et\nles candidatures qui vous sont deposés",
    event: "",
    img: "assets/rent.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item5 = new Items(
    id:5,
    title: "Mes Transactions",
    subtitle: "Historique de toutes vos transactions monétaires",
    event: "",
    img: "assets/transaction.jpg",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item6 = new Items(
    id:6,
    title: "Mes factures",
    subtitle: "Consulter et administrer toutes vos factures",
    event: "",
    img: "assets/paie.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item7 = new Items(
    id:7,
    title: "Mes offres de service",
    subtitle: "Consulter et administrer tous les offres de service qui vous sont adréssés",
    event: "",
    img: "assets/contrat.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item8 = new Items(
      id:8,
      title: "Mes abonnements",
      subtitle: "Consulter et gérer tous les abonnements auquels vous avez souscrit.",
      event: "",
      img: "assets/contrat.png",
      link : "https://niovarjobs.com/Inscrires/Login"
  );
  Items item9 = new Items(
      id:9,
      title: "Gérer utilisateurs",
      subtitle: "Inviter et gérer les utilisateurs",
      event: "",
      img: "assets/contrat.png",
      link : "https://niovarjobs.com/Inscrires/Login"
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
            onTap: () async {
              Constante.showAlertRedirectWebSite(context, data.link);
            },
            child:  Container(
              padding: EdgeInsets.symmetric(vertical: 10,),
              decoration: BoxDecoration(
                color: Color(0xFFF37B3E),
                borderRadius: BorderRadius.circular(10),
              ),
              child:SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(data.img, width: 40),
                    SizedBox(height: 5),

                    Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.all(5),
                      child: Center(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            data.title,
                            style: GoogleFonts.openSans(
                              textStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        )

                      )

                    ),

                    SizedBox(height: 2),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child:Align(
                        alignment: Alignment.center,
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
                      )

                    ),

                  ],
                ),
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
  String link;
  Items({ required this.id, required this.title, required this.subtitle, required this.event, required this.img, required this.link});
}
