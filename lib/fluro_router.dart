import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart' as fluro;
import 'pages/home_page.dart';
import 'pages/printers_page.dart';
import 'pages/printer_page.dart';

class Routes {
  static const home = "/";
  static const printers = "/printers/";
  static const printer_id = "/printer/:id";

  static String printerId(int id) => "/printer/$id";
}

class FluroRouter {
  static final router = fluro.Router();
  static final _homeHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => MyHomePage());
  static final _printersHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => PrintersPage());
  static final _printerHandler = fluro.Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) => PrinterPage(id: params['id'][0]));

  static void setupRouter() {
    router.define(Routes.home,  handler: _homeHandler);
    router.define(Routes.printers, handler: _printersHandler);
    router.define(Routes.printer_id, handler: _printerHandler);
  }
}