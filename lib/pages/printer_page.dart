import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/printer.dart';
import '../models/plan.dart';
import '../my_database.dart';
import '../utils/config.dart';
import '../fluro_router.dart';

class PrinterPage extends StatefulWidget {
  PrinterPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _PrinterPageState createState() => _PrinterPageState(int.parse(id));
}

class _PrinterPageState extends State<PrinterPage> {

  _PrinterPageState(this.id);

  Printer _printer = Printer(Printer.models[0], "");

  int id;

  final _formKey = GlobalKey<FormState>();
  final _urlCtrl = TextEditingController();
  final _invDayCtrl = TextEditingController();
  final _currPagCtrl = TextEditingController();
  final _accumPagCtrl = TextEditingController();


  @override
  void dispose() {
    _urlCtrl.dispose();
    _invDayCtrl.dispose();
    _currPagCtrl.dispose();
    _accumPagCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    MyDatabase.getPrinter(this.id).then((value) {
      if (value != null) {
        print(value.toMap());
        setState(() {
          _printer = value;
          _accumPagCtrl.text = _printer.pagesAccum.toString();
          _urlCtrl.text = _printer.url;
          _currPagCtrl.text = _printer.pagesCurr.toString();
          _invDayCtrl.text = _printer.invoicingDay.toString();
        });
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    var title = (widget.id == "0") ? "New printer" : 'This is printer ${widget.id}!';
    var thePlans = Config().plans;

    int pagesFromPlanPricing(price) {
      for (int p=0;p<thePlans.length;p++) {
        if (thePlans[p].price == price){
          return thePlans[p].pages;
        }
      }
      return 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, Routes.printers);
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: null),
        ],
      ),
      body: Center(child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.85,
        child: Form(
          key: _formKey,
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
            Padding(padding: EdgeInsets.only(top: 20.0)),
            DropdownButton<String>(
              value: _printer.name,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String newValue) { setState(() { _printer.name = newValue;});},
              items: Printer.models.map<DropdownMenuItem<String>>((String value) =>
                DropdownMenuItem<String>(value: value, child: Text(value))).toList(),
            ),
            TextFormField(
              key: Key("url" + _printer.url),
              controller: _urlCtrl,
              // initialValue: _printer.url,
              decoration: const InputDecoration(
                labelText: 'Printer url',
                hintText: 'IP or local domain of the printer',
              ),
              // onChanged: (String value) { setState(() {_printer.url = value;});},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some IP or local domain';
                }
                return null;
              },
            ),
            DropdownButton<String>(
              key: Key(_printer.planName),
              value: _printer.planName,
              icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              items: thePlans.map<DropdownMenuItem<String>>((Plan value) =>
                 DropdownMenuItem<String>(child: Text(value.toString()), value: value.price)).toList(),
              onChanged: (String newValue) {
                setState(() {
                  _printer.planName = newValue;
                  _printer.pagesPlan = pagesFromPlanPricing(newValue);
                });
              },
            ),
            TextFormField(
              key: Key("invoicing" + _printer.invoicingDay.toString()),
              controller: _invDayCtrl,
              //initialValue: _printer.invoicingDay.toString(),
              decoration: const InputDecoration(
                labelText: 'Invoicing Day',
                hintText: 'They day of the month HP closes the invoice',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              // onChanged: (String value) { setState(() {_printer.invoicingDay = int.parse(value);});},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some number between 1 and 31';
                }
                try {
                  var v = int.parse(value);
                  if (v<1 || v>31){
                    return "A number between 1 and 31, please";
                  }
                }catch(e){
                  return "A number between 1 and 31, please";
                }
                return null;
              },
            ),
            TextFormField(
              key: Key("pagesCurr" + _printer.pagesCurr.toString()),
              controller: _currPagCtrl,
              //initialValue: _printer.pagesCurr.toString(),
              decoration: const InputDecoration(
                labelText: 'Current amount of pages',
                hintText: 'The number of pages HP says you have already printed',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              // onChanged: (String value) {setState(() {_printer.pagesCurr = int.parse(value);});},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some number greater than 1';
                }
                try {
                  var v = int.parse(value);
                  if (v<1){
                    return "A number greater than 1, please";
                  }
                }catch(e){
                  return "A number greater than 1, please";
                }
                return null;
              },
            ),
            TextFormField(
              key: Key("pagesAccum" + _printer.pagesAccum.toString()),
              controller: _accumPagCtrl,
              //initialValue: _printer.pagesAccum.toString(),
              decoration: const InputDecoration(
                labelText: 'Pending pages from last months',
                hintText: 'The number of pages you accumulate from last months according to HP',
              ),
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              //onChanged: (String value) { setState(() { _printer.pagesAccum = int.parse(value); });},
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some number';
                }
                try {
                  var v = int.parse(value);
                }catch(e){
                  return "A number, please";
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState.validate()) {
                    _printer.url = _urlCtrl.text;
                    _printer.pagesAccum = int.parse(_accumPagCtrl.text);
                    _printer.pagesCurr = int.parse(_currPagCtrl.text);
                    _printer.lastGrandTotal = _printer.status.totalPages;
                    _printer.lastDayChecked = DateTime.now().day;
                    await MyDatabase.insertPrinter(_printer).then((value) => {
                          if (value)
                            {Navigator.pushReplacementNamed(context, Routes.printers)}
                        });
                  }
                },
                child: Text('Submit'),
              ),
            ),
          ]),
        ),
      ),
      ),
    );
  }
}
