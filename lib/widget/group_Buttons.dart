
import 'package:flutter/material.dart';
import 'package:group_button/group_button.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';


import '../Constante.dart';
 Widget groupButtons(BuildContext context){
   return Padding(
     padding: const EdgeInsets.all(8.0),
     child:CustomRadioButton(
       unSelectedBorderColor: Colors.black54,
       margin: EdgeInsets.symmetric(horizontal: 5),
       enableShape: true,
       elevation: 0,
       absoluteZeroSpacing: true,
       unSelectedColor: Theme.of(context).canvasColor,
       horizontal: false,
       buttonLables: [
         'Student',
         'Parent',
         'Teacher',
       ],
       buttonValues: [
         "STUDENT",
         "PARENT",
         "TEACHER",
       ],
       buttonTextStyle: ButtonTextStyle(
           selectedColor: Colors.white,
           unSelectedColor: Colors.black,
           textStyle: TextStyle(fontSize: 16)),
       radioButtonValue: (value) {
         print(value);
       },
       selectedColor: Constante.kOrange,

       selectedBorderColor: Colors.orange,

     ),

   );
 }

