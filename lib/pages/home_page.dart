import 'package:flutter/material.dart';
import '../models/printer.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Printer> _printers = [
    Printer("Envy 5540", "192.168.0.47"),
    Printer("Envy 3383", "192.168.0.112"),
  ];

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("My printers"),
      ),
      body: ListView.builder(
        itemCount: _printers.length,
        itemBuilder: _itemBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Add printer',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Card(
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(child: Text("P")),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(_printers[index].name,
                    style: TextStyle(fontSize: 20.0)),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(_printers[index].url,
                    style: TextStyle(fontSize: 17.0)),
              ],
            )
        ),
        onTap: () => Navigator.pushReplacementNamed(context, "/printer/$index"),
      ),
    );
  }
}
