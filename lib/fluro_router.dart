import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'pages/home_page.dart';
import 'pages/printer_page.dart';


class FluroRouter {
  static final router = fluro.Router();
  static final _homeHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => MyHomePage());
  static final _printerHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => PrinterPage(id: params['id'][0]));

  static void setupRouter() {
    router.define('/',  handler: _homeHandler);
    router.define('/printer/:id', handler: _printerHandler);
  }
}