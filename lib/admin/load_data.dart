import 'dart:developer' as logging;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:csv/csv.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(5.0, 50, 5, 5),
          child: Column(
            children: [
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _loadCSV,
                    child: Text("load Lebensräume by Arten"),
                  ),
                  SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: _upload,
                    child: Text("Upload data"),
                  )
                ],
              ),
              Text("loaded csv:"),
              Text(_data.toString()),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadCSV() async {
    final data = await rootBundle.loadString(
      'res/lebensraume-by-arten.csv',
    );
    final csv = const CsvToListConverter().convert(data, fieldDelimiter: ";");
    setState(() {
      _data = csv;
    });
  }

  Future<void> _upload() async {
    for (final List line in _data) {
      if (line[0] == '') {
        // jump over empty lines
        continue;
      }
      //load document from database
      final doc = await FirebaseFirestore.instance
          .collection("species")
          .doc(line[3])
          .get();

      final supportedBy = {};
      for (var i = 4; i < line.length; i++) {
        if (line[i] == 1) {
          supportedBy.addAll({_data[0][i]: true});
        }
      }

      final updateMap = {
        "name": line[3],
        "type": line[2],
        "class": line[1],
        "supportedBy": supportedBy
      };
      if (doc.exists) {
        FirebaseFirestore.instance.doc("species/${line[3]}").update(updateMap);
      } else {
        FirebaseFirestore.instance.doc("species/${line[3]}").set(updateMap);
      }
      logging.log("Upload Map: $updateMap");
    }
  }
}
