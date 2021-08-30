import 'dart:async';
import 'dart:io';

import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

import '../Constante.dart';

class PageCompagny extends StatefulWidget {
   int idPage;
  PageCompagny({ required this.idPage});

  @override
  _PageCompagny createState() => _PageCompagny(idPage);
}

class _PageCompagny extends State<PageCompagny> {
 late int page ;

 _PageCompagny(this.page);

  late WebViewController controller;
 final Completer<WebViewController> _controllerCompleter =
 Completer<WebViewController>();

 Future<void> _onWillPop(BuildContext context) async {
   if (await controller.canGoBack()) {
     controller.goBack();
   } else {
     exit(0);
     return Future.value(false);
   }
 }

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
   return Scaffold(
     backgroundColor: Constante.kSilver,
     appBar: AppBar(
       backgroundColor: Constante.kSilver,
       elevation: 0,
       leading: IconButton(
         icon: Icon(
           Icons.arrow_back_ios,
           color: Constante.kBlack,
         ),
         onPressed: () => Navigator.pop(context),
       ),
       title: Text(
         "Page de la compagnie",
         style: Constante.kTitleStyle,
       ),
       centerTitle: true,
     ),

     body: WebView(
       initialUrl: Constante.serveurAdress+"Home/AproposHome/"+page.toString()+"?vp=5",
       javascriptMode: JavascriptMode.unrestricted,
       onWebViewCreated: (WebViewController c) {
         _controllerCompleter.future.then((value) => controller = value);
         _controllerCompleter.complete(c);
       },
       onPageFinished: (String url) {
         print('Page finished loading: $url');

         // Removes header and footer from page
         controller
             .evaluateJavascript("javascript:(function() { " +
             "var head = document.getElementsByTagName('header')[0];" +
             "head.parentNode.removeChild(head);" +
             "var footer = document.getElementsByTagName('footer')[0];" +
             "footer.parentNode.removeChild(footer);" +
             "})()")
             .then((value) => debugPrint('Page finished loading Javascript'))
             .catchError((onError) => debugPrint('$onError'));
       },

     ),
   );

  }
}