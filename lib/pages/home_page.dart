import 'package:flutter/material.dart';
import '../utils/config.dart';
import '../fluro_router.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, String>> countries = [
    {"flag": "es", "code": "es", "language": "es", "label": "España (Español)"},
    {"flag": "gb", "code": "uk", "language": "en", "label": "United Kingdom (English)"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My printers"),
      ),
      body: Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Center(child: Text("Select your country", style: TextStyle(fontSize: 20))),
          Padding(padding: EdgeInsets.only(top: 10.0)),
          Expanded(child: ListView.builder(
            itemCount: countries.length,
            itemBuilder: _itemBuilder,
          ),
          )
        ]
      )
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Card(
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Image(image: AssetImage("assets/${countries[index]["flag"]}-flag.png")),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(countries[index]["label"],
                    style: TextStyle(fontSize: 20.0)),
              ],
            )
        ),
        onTap: () {
          var config = Config();
          config.readProviderInfo(countries[index]["code"], countries[index]["language"]);
          Navigator.pushReplacementNamed(context, Routes.printers);
        }
      ),
    );
  }
}
