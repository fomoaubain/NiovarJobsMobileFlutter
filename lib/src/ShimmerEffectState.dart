import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:niovarjobs/src/CvPage.dart';
import 'package:niovarjobs/src/ManageAlerte.dart';
import 'package:niovarjobs/src/MesAffectations.dart';
import 'package:niovarjobs/src/MesCandidatures.dart';
import 'package:niovarjobs/src/MesContratTravail.dart';
import 'package:niovarjobs/src/MesLocationsCdt.dart';
import 'package:niovarjobs/src/mesDocuments.dart';
import 'package:niovarjobs/src/mesTalonPaie.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerEffectState extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            child: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              direction: ShimmerDirection.ltr,
              child: ListView.builder(
                itemBuilder: (_, __) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        width: 48.0,
                        height: 48.0,
                        color: Colors.white,
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8.0),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: double.infinity,
                              height: 8.0,
                              color: Colors.white,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 2.0),
                            ),
                            Container(
                              width: 40.0,
                              height: 8.0,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                itemCount: 8,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

