import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Job.dart';

import 'package:niovarjobs/model/Postuler.dart';

class DescriptionTab extends StatelessWidget {

  final Postuler postuler;
  DescriptionTab({required this.postuler});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: <Widget>[
          SizedBox(height: 20,),
          Container(
            child: Row(
              children: [
                Expanded(
                    child: Center(
                      child:_buildButtonColumn2( Icons.monetization_on_sharp,Constante.getSalaire(postuler.job), "Salaire",  Colors.black45, 15 ),
                    )
                ),
                Expanded(
                    child: Center(
                      child: _buildButtonColumn2( Icons.work,postuler.job.margeExperience, "Expérience",  Colors.black45, 15 ),
                    )
                ),

              ],
            ),
          ),

          SizedBox(height: 20.0),
          Text(
            "Desciption",
            style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
        textSection(postuler.job.description),
          SizedBox(height: 15.0),
          postuler.job.instantane== 1 ? SizedBox() : Text(
            "Responsabilitees",
            style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          postuler.job.instantane== 1 ? SizedBox() :textSection(postuler.job.responsabilite),
          SizedBox(height: 15.0),
          postuler.job.instantane== 1 ? SizedBox() :Text(
            "Exigences et competences",
            style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10.0),
          postuler.job.instantane== 1 ? SizedBox() : textSection(postuler.job.exigence),
          SizedBox(height: 15,),
          postuler.job.instantane== 1 ? SizedBox() : Text(
            "Diplomes necessaires",
            style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          postuler.job.instantane== 1 ? SizedBox() : Column(
            children: postuler.job.lisDiplome
                .map(
                  (e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0,),
                  Text.rich(
                    TextSpan(
                      style: Constante.kSubtitleStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                        color: Color(0xFF5B5B5B),
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.arrow_right,color:Colors.orange, size: 14.0,),
                        ),
                        TextSpan(
                          text: e.libelle,
                        )
                      ],
                    ),
                  )

                ],
              ),
            )
                .toList(),
          ),
          SizedBox(height: 15,),
          postuler.job.instantane== 1 ? SizedBox() : Text(
            "Avantages sociaux",
            style: Constante.kTitleStyle.copyWith(fontWeight: FontWeight.bold),
          ),
          postuler.job.instantane== 1 ? SizedBox() : Column(
            children: postuler.job.avantageSociauxJob
                .map(
                  (e) => Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 5.0,),
                  Text.rich(
                    TextSpan(
                      style: Constante.kSubtitleStyle.copyWith(
                        fontWeight: FontWeight.w300,
                        height: 1.5,
                        fontSize: 11,
                        color: Color(0xFF5B5B5B),
                      ),
                      children: [
                        WidgetSpan(
                          child: Icon(Icons.arrow_right,color:Colors.orange, size: 14.0,),
                        ),
                        TextSpan(
                          text: e.avantageSociaux.libelle,
                        )
                      ],
                    ),
                  )

                ],
              ),
            )
                .toList(),
          ),
          SizedBox(height: 10,),
          ShowEQuiteEmploi(postuler.job),
        ],
      ),
    );
  }


  Widget textSection(String text){
    return   Container(
      padding: EdgeInsets.symmetric(vertical: 0.0, horizontal: 10),
      child: SingleChildScrollView(
        child: Html(
          data: text,
        ),
      ),

    );
  }

  Column _buildButtonColumn(IconData icon, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, color: Colors.orange, size: 23,),
        Container(
          alignment: Alignment.center,
          width: 150.0,
          margin: const EdgeInsets.only(top:0, left: 10, right: 10),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black45,
            ),
          ),
        ),
      ],
    );
  }

  Widget ShowEQuiteEmploi( Job job){
    String a = job.equipeEmploi;

    if(a.contains('1')){
      return Container(
        padding: EdgeInsets.only(left: 0.0),
        child: Text( "Equité en emploi : Cet employeur souscrit aux principes d'équité et applique un programme d'accès à l'égalité en emploi pour les femmes, les autochtones, les minorités visibles, les minorités ethniques et les personnes handicapées"
          , style: TextStyle(color: Colors.black54),),

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
            label,
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



}
