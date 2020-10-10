import 'package:flutter/material.dart';
import '../models/printer.dart';
import '../my_database.dart';

class PrinterPage extends StatefulWidget {
  PrinterPage({Key key, this.id}) : super(key: key);

  final String id;

  @override
  _PrinterPageState createState() => _PrinterPageState();
}

class _PrinterPageState extends State<PrinterPage> {

  Printer printer = Printer("", "");

  final nameController = TextEditingController();

  final urlController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    nameController.dispose();
    urlController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.home),
          onPressed: () {
            // Navigator.of(context).pop();
            Navigator.pushReplacementNamed(context, "/");
          },
        ),
        actions: [
          IconButton(icon: Icon(Icons.save), onPressed: null),
        ],
        title: Text('Home'),
      ),
      body: Form(
         key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Center(child: Text('This is printer ${widget.id}!')),
              TextFormField(
                autofocus: true,
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Printer model',
                  hintText: 'Printer model/name',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: urlController,
                decoration: const InputDecoration(
                  labelText: 'Printer url',
                  hintText: 'IP or local domain of the printer',
                ),
                validator: (value) {
                  if (value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      printer.name = nameController.text;
                      printer.url = urlController.text;
                      await MyDatabase.insertPrinter(printer).then((value) => {
                         if (value) {
                            Navigator.pushReplacementNamed(context, "/")
                         }
                      });
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ]
          ),
      ),
    );
  }
}
