import 'package:flutter/material.dart';
import 'package:niovarjobs/Constante.dart';


Widget customButton(text,function){
  return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      color: Constante.kBlack,
      child: InkWell( onTap: function,
        child: Container(
          height: 55,
          width: double.infinity,
          child: Center(
            child: Text(text,style: Constante.kTitleStyle.copyWith(
              color: Colors.white,
              fontSize: 14.0,
              fontWeight: FontWeight.w400
            ),),
          ),
        ),
        borderRadius: BorderRadius.circular(10),
      )
  );
}