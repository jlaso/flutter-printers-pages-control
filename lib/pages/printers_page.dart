import 'package:flutter/material.dart';
import 'dart:async';
import '../models/printer.dart';
import '../my_database.dart';
import '../fluro_router.dart';

const TIMER_SECONDS = 60;

class PrintersPage extends StatefulWidget {
  PrintersPage({Key key}) : super(key: key);

  @override
  _PrintersPageState createState() => _PrintersPageState();
}

class _PrintersPageState extends State<PrintersPage> {
  Future<List<Printer>> printers;
  Timer timer;

  @override
  void initState() {
    super.initState();
    printers = MyDatabase.getPrinters();
    updatePrinterStatuses();
  }

  void updatePrinterStatuses() async{
    timer?.cancel();
    printers.then((value) {
      value.forEach((printer) async {
        await printer.status.update();
      });
      Future.delayed(Duration(seconds:1), () {
        setState(() {
          timer = Timer.periodic(Duration(seconds:TIMER_SECONDS),
                  (Timer t) => updatePrinterStatuses());
        });
      });
    });
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
      body: fbuilder(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushReplacementNamed(context, Routes.printerId(0)),
        tooltip: 'Add printer',
        child: Icon(Icons.add),
      ),
    );
  }

  Widget fbuilder() {
    return FutureBuilder<List<Printer>>(
      future: printers,
      builder: (BuildContext context, printersSnap) {
        // print("hasData ${printersSnap.hasData}");
        if (!printersSnap.hasData || printersSnap.data == null)
          return Center(child: CircularProgressIndicator());
        return ListView.builder(
          itemCount: printersSnap.data.length,
          itemBuilder: (BuildContext context, int index) {
            var printer = printersSnap.data[index];
            return Card(
              child: InkWell(
                child: Container(
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      key: Key("row$index"),
                      // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        CircleAvatar(child: Icon(Icons.print)),
                        Padding(padding: EdgeInsets.only(right: 10.0)),
                        Text(printer.name,
                            style: TextStyle(fontSize: 20.0)),
                        Padding(padding: EdgeInsets.only(right: 20.0)),
                        Text("url: "+ printer.url,
                            style: TextStyle(fontSize: 17.0)),
                        Padding(padding: EdgeInsets.only(right: 10.0)),
                        Text("SN: "+ printer.status.serialNumber,
                            style: TextStyle(fontSize: 17.0)),
                        Padding(padding: EdgeInsets.only(right: 10.0)),
                        Expanded(
                          child: Text(
                              "pages: " + printer.pagesLeft().currentMonth.toString(),
                              textAlign: TextAlign.right,
                              style: TextStyle(fontSize: 17.0)),
                        )
                      ],
                    )
                ),
                onTap: () =>
                    Navigator.pushReplacementNamed(
                        context, Routes.printerId(printer.id)),
              ),
            );
          },
        );
      });
  }

}
