import 'package:flutter/material.dart';
import 'dart:async';
import '../models/printer.dart';
import '../my_database.dart';
import '../fluro_router.dart';
import '../utils/printer_status.dart';

class PrintersPage extends StatefulWidget {
  PrintersPage({Key key}) : super(key: key);

  @override
  _PrintersPageState createState() => _PrintersPageState();
}

class _PrintersPageState extends State<PrintersPage> {
  List<Printer> _printers = List<Printer>();
  Map<String, PrinterStatus> statuses = Map<String, PrinterStatus>();
  Timer timer;

  @override
  void initState() {
    MyDatabase.getPrinters().then((value) {
        setState(() { _printers = value;});
        value.forEach((printer) {
            statuses[printer.url] = PrinterStatus(printer);
        });
        updatePrinterStatuses();
    });
    super.initState();
  }

  void updatePrinterStatuses() async{
    timer?.cancel();
    _printers.forEach((printer) async {
      print("getting info of $printer");
        await statuses[printer.url].update();
    });
    timer = Timer.periodic(Duration(seconds:60), (Timer t) => updatePrinterStatuses());
  }

  String pStatus(index) {
    var url = _printers[index].url;
    if (statuses == null || !statuses.containsKey(url)) {
      return "";
    }
    var s = statuses[url];
    if (s is PrinterStatus) {
      return s.totalPages.toString();
    }
    return "";
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {Navigator.pushReplacementNamed(context, Routes.home);},),
        title: Text("My printers"),
      ),
      body: ListView.builder(
        itemCount: _printers.length,
        itemBuilder: _itemBuilder,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.printerId(0)),
        tooltip: 'Add printer',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _itemBuilder(BuildContext context, int index) {
    return Card(
      child: InkWell(
        child: Container(
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                CircleAvatar(child: Icon(Icons.print)),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(_printers[index].name,
                    style: TextStyle(fontSize: 20.0)),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(_printers[index].url,
                    style: TextStyle(fontSize: 17.0)),
                Padding(padding: EdgeInsets.only(right: 10.0)),
                Text(pStatus(index), key: Key("status$index"),
                    style: TextStyle(fontSize: 17.0)),
              ],
            )
        ),
        onTap: () => Navigator.pushReplacementNamed(context, Routes.printerId(_printers[index].id)),
      ),
    );
  }
}
