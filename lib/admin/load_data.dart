import 'package:biodiversity/admin/upload_images.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

/// Only used for admin purposes, should not be used in production
/// The page provides the possibility to upload new data into the database
class LoadData extends StatefulWidget {
  /// default constructor
  LoadData({Key key}) : super(key: key);

  @override
  _LoadDataState createState() => _LoadDataState();
}

class _LoadDataState extends State<LoadData> {
  double _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    // Make sure that the class will not be used in a release version
    assert(!kReleaseMode);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Data loading, ADMINS ONLY'),
        leading: IconButton(
          onPressed: () => Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => UploadImages())),
          icon: const Icon(Icons.next_plan_outlined),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'This page allows you to upload information about species '
              'and biodiversity Elements to the database.\n'
              'This page should only be used by developers.\n\n\n\n'
              'The content is not checked for correctness.\n\n'
              'Always make sure the data provided is correct before uploading !\n\n'
              'The Excel file should be stored in the folder:\n'
              'res/data/Lebensraume-und-Arten.xlsx\n',
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                  onPressed: _loadData,
                  label: const Text('Upload Data'),
                  icon: const Icon(Icons.backup_rounded),
                ),
                const SizedBox(height: 15),
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 15),
                if (_progress == 1)
                  const Text('All data loaded and saved to the server :)'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _loadData() async {
    List _data;
    final file = await rootBundle.load('res/data/Lebensraume-und-Arten.xlsx');
    final byteData = file.buffer.asUint8List();
    final excel = Excel.decodeBytes(byteData);
    assert(excel.sheets.containsKey('Liste Lebensräume'));
    assert(excel.sheets.containsKey('Arten-by-Lebensraum'));
    assert(excel.sheets.containsKey('Lebensraum-by-Lebensraum'));
    assert(excel.sheets.containsKey('Arten-by-Arten'));
    setState(() => _progress = 0);

    // Load data about the Lebensräume
    _data = excel.tables['Liste Lebensräume'].rows;
    setState(() => _progress += 0.1);
    for (final List line in _data.skip(1)) {
      if (line[0] == '') continue;
      final updateMap = {
        'type': line[1],
        'name': line[2],
        'dimension': line[3],
        'unit': line[4]
      };
      await _upload(updateMap, 'biodiversityMeasures', line[2]);
    }
    setState(() => _progress += 0.1);

    // load data about the Arten - Lebensräume relationship
    _data = excel.tables['Arten-by-Lebensraum'].rows;
    setState(() => _progress += 0.1);
    var _lebensraume = Map<String, List<String>>.fromIterable(_data[0].skip(4),
        key: (v) => v, value: (v) => []);
    for (final List line in _data.skip(1)) {
      if (line[0] == '') continue;
      final supportedBy = [];
      for (var i = 4; i < line.length; i++) {
        if (line[i] == 1) {
          supportedBy.add(_data[0][i]);
          _lebensraume[_data[0][i]].add(line[3]);
        }
      }
      final updateMap = {
        'name': line[3],
        'type': line[2],
        'class': line[1],
        'supportedBy': supportedBy
      };
      await _upload(updateMap, 'species', line[3]);
    }
    setState(() => _progress += 0.1);
    // also load the data to the Lebensräume
    for (final lebensraum in _lebensraume.keys) {
      final map = {
        'beneficialFor': _lebensraume[lebensraum],
        'name': lebensraum
      };
      await _upload(map, 'biodiversityMeasures', lebensraum);
    }
    setState(() => _progress += 0.1);

    // Load data about the relationship between two Lebensräume
    _data = excel.tables['Lebensraum-by-Lebensraum'].rows;
    setState(() => _progress += 0.1);
    var goodTogetherWith = _readMatrix(_data);
    for (final habitat in goodTogetherWith.keys) {
      final updateMap = {
        'goodTogetherWith': goodTogetherWith[habitat].toList()
      };
      await _upload(updateMap, 'biodiversityMeasures', habitat);
    }

    // load data about the relationship between two arten
    _data = excel.tables['Arten-by-Arten'].rows;
    setState(() => _progress += 0.1);
    final connectedTo = _readMatrix(_data);
    for (final art in connectedTo.keys) {
      final updateMap = {'connectedTo': connectedTo[art].toList()};
      await _upload(updateMap, 'species', art);
    }
    setState(() => _progress = 1);
  }

  Map _readMatrix(List matrix) {
    var output = {};
    for (final List line in matrix.skip(1)) {
      if (line[0] == '') continue;
      var associated = <String>[];
      for (var i = 1; i < line.length; i++) {
        if (line[i] == 1 && line[0] != matrix[0][i]) {
          associated.add(matrix[0][i]);
        }
      }
      output[line[0]] = associated;
    }
    return output;
  }

  Future<void> _upload(Map updateMap, String collection, String docName) async {
    //logging.log("Would upload to $collection/$docName: $updateMap");
    final doc =
        await FirebaseFirestore.instance.doc('$collection/$docName').get();
    if (doc.exists) {
      await FirebaseFirestore.instance
          .doc('$collection/$docName')
          .update(updateMap);
    } else {
      await FirebaseFirestore.instance
          .doc('$collection/$docName')
          .set(updateMap);
    }
  }
}
