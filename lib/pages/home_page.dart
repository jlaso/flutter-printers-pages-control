import 'package:flutter/material.dart';
import '../models/printer.dart';
import '../my_database.dart';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  List<Printer> _printers = List<Printer>();

  @override
  void initState() {
    MyDatabase.getPrinters().then((value) =>
      setState(() {_printers = value;})
    );
    super.initState();
  }

  void _incrementCounter() {
    setState(() {
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
