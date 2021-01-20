import 'dart:developer' as logging;
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Only used for admin purposes, should not be used in production
/// The page provides the possibility to upload new data into the database
class LoadData extends StatefulWidget {
  @override
  _LoadDataState createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  String _entry = "";
  List _data;

  @override
  Widget build(BuildContext context) {
    // Make sure that the class will not be used in a release version
    assert(!kReleaseMode);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(50.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: _loadCSV,
              child: Text("CSV öffnen"),
            ),
            Text("First entry:"),
            Text(_entry),
          ],
        ),
      ),
    );
  }

  Future<void> _loadCSV() async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: false);
    if (result != null) {
      final file = File(result.files.single.path);
      final csv = const CsvToListConverter().convert(file.readAsStringSync(),
          fieldDelimiter: "", textDelimiter: "");
      setState(() {
        _entry = csv[9].toString();
      });
    }
  }
}
