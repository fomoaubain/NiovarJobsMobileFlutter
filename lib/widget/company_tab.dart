import 'package:flutter/material.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Job.dart';

import 'package:niovarjobs/model/Postuler.dart';

class CompanyTab extends StatelessWidget {
  final Postuler postuler;
  CompanyTab({required this.postuler});
  @override
  Widget build(BuildContext context) {
    return  Container(

      child: ListView(
        children: <Widget>[
          SizedBox(height: 0.0),
          Container(
            alignment: Alignment.topCenter,
            child: Row(
              children: [
                Expanded(
                    child:Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 15,),
                        _buildButtonColumn2( Icons.date_range,postuler.job.horaireTravail, "Horaires de travail",  Colors.black45, 13 ),
                        Divider(),
                        SizedBox(height: 15,),
                        _buildButtonColumn2( Icons.date_range,postuler.job.dateFinOffre, "Date fin offre",  Colors.black45, 13 ),
                        Divider(),
                        SizedBox(height: 10,),
                        postuler.job.instantane== 1 ? SizedBox() : _buildButtonColumn2( Icons.calendar_today_sharp,postuler.job.jourTravail, "Jour de travail",  Colors.black45, 13 ),
                        Divider(),
                        SizedBox(height: 10,),
                        _buildButtonColumn2( Icons.work,postuler.job.quartravail.libelle, "Quart de travail",  Colors.black45, 13 ),
                        Divider(),
                        SizedBox(height: 0,),
                        _buildButtonColumn2( Icons.timer,postuler.job.typeOffre.libelle, "Type d'offre",  Colors.black45, 13 ),
                        Divider(),
                      ],
                    )
                ),
                Expanded(child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 10,),
                          _buildButtonColumn2( Icons.work_outline,postuler.job.categorie.libelle, "Categorie",  Colors.black45, 13 ),
                          Divider(),
                          SizedBox(height: 10,),
                          postuler.job.instantane== 1 ? SizedBox() : _buildButtonColumn2( Icons.school,postuler.job.niveauScolarite.libelle, "Niveau de scolarite",  Colors.black45, 13 ),
                          Divider(),
                          SizedBox(height: 10,),
                          postuler.job.instantane== 1 ? SizedBox() : _buildButtonColumn2( Icons.school_outlined,postuler.job.statutEmploi.libelle, "Statut formatiom",  Colors.black45, 13 ),
                          Divider(),
                          SizedBox(height: 10,),
                          postuler.job.instantane== 1 ? SizedBox() : _buildButtonColumn2( Icons.file_copy,postuler.job.contrat.libelle, "Type contrat",  Colors.black45, 13 ),
                          SizedBox(height: 10,),
                          ShowEmplacementeExacr(postuler.job),
                        ],
                      ),
                    )
                  ],
                ),)

              ],

            ),
          )

        ],
      ),
    );


  }

  Text TextwithIcon(IconData icon, String text, Color colors, double textsize){
    return  Text.rich(
      TextSpan(
        style: TextStyle(
            fontSize: textsize,
            color: colors
        ),
        children: [
          WidgetSpan(
            child: Icon(icon,color:Colors.orange, size: 14.0,),
          ),
          TextSpan(
            text: text,
          )
        ],
      ),
    );
  }

  Widget ShowEmplacementeExacr( Job job){
    String a = job.masquerEmplacement.toString();

    if(a=="1"){
      return Container(
        padding: EdgeInsets.only(left: 0.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildButtonColumn2( Icons.location_city,job.adressePostal, "Adresse complete",  Colors.black45, 13 ),
            SizedBox(height: 10,),
            _buildButtonColumn2( Icons.location_on,job.codePostal, "Code postale",  Colors.black45, 13 ),
          ],
        ),
      );
    }
    return   SizedBox();
  }

  Column _buildButtonColumn2(IconData icon, String label, String text, Color color, double size) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextwithIcon(icon, text, color, size),
        Container(
          margin: const EdgeInsets.only(top:0, left: 10, right: 10),
          child: Text(
            label !=null ? label : "Aucune donnée",
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }




}


