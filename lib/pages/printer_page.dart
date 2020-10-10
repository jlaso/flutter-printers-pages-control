import 'package:flutter/material.dart';
import '../models/printer.dart';

class PrinterPage extends StatelessWidget {
  PrinterPage({Key key, this.id}) : super(key: key);

  final String id;

  final _formKey = GlobalKey<FormState>();

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
              Center(child: Text('This is printer $id!')),
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Printer model/name',
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
                  onPressed: () {
                    // Validate will return true if the form is valid, or false if
                    // the form is invalid.
                    if (_formKey.currentState.validate()) {
                      // Process data.
                    }
                  },
                  child: Text('Submit'),
                ),
              ),
            ]
          ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.settings_backup_restore),
        onPressed: () {},
      ),
    );
  }
}
