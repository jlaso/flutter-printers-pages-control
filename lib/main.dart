import 'package:flutter/material.dart';
import 'models/printer.dart';
import 'fluro_router.dart';


void main() {
  FluroRouter.setupRouter();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // var routes = <String, WidgetBuilder>{
  //   '/': (BuildContext context) => MyHomePage(),
  //   '/printer/:id': (BuildContext context) => PrinterPage(),
  // };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      // home: MyHomePage(title: 'Printers Page Number Control'),
      // routes: routes,
        onGenerateRoute: FluroRouter.router.generator,
    );
  }
}
