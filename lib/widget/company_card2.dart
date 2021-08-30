import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:niovarjobs/Constante.dart';
import 'package:niovarjobs/model/Inscrire.dart';

class CompanyCard2 extends StatelessWidget {
  final Inscrire company;
  CompanyCard2({required this.company});
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280.0,
      margin: EdgeInsets.only(right: 15.0),
      padding: EdgeInsets.all(15.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                decoration: new BoxDecoration(
                    border: new Border(
                        right: new BorderSide(width: 1.0, color: Colors.white24))),
                child: Card(
                  child: CachedNetworkImage(
                    width: 60.0,
                    imageUrl: Constante.serveurAdress+company.profilCompagnie,
                    placeholder: (context, url) => CupertinoActivityIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              Spacer(),
              Text(
                company.telRepresentant,
                style: Constante.kTitleStyle,
              ),
            ],
          ),
          SizedBox(height: 15.0),
          Text(
            company.nom,
            style: Constante.kTitleStyle,
          ),
          SizedBox(height: 5.0),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: company.pays,
                  style: Constante.kSubtitleStyle,
                ),
                TextSpan(
                  text: "  •  ",
                  style: Constante.kSubtitleStyle,
                ),
                TextSpan(
                  text: company.province,
                  style: Constante.kSubtitleStyle,
                ),
                TextSpan(
                  text: "  •  ",
                  style: Constante.kSubtitleStyle,
                ),
                TextSpan(
                  text: company.ville,
                  style: Constante.kSubtitleStyle,
                ),
              ],
            ),
          ),
          SizedBox(height: 15.0),
          Expanded(child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(right: 10.0),
                padding:
                EdgeInsets.symmetric(horizontal: 12.0, vertical: 5.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                  color: Colors.orange,
                ),
                child: Text(
                  company.NbrePost+" offres d'emploi disponible",
                  style: Constante.kSubtitleStyle.copyWith(
                    color: Colors.white,
                    fontSize: 12.0,
                  ),
                ),
              ),
            ],
          ))

        ],
      ),
    );
  }
}
