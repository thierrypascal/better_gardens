import 'dart:io';

import 'package:archive/archive.dart';
import 'package:biodiversity/admin/load_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spreadsheet_decoder/spreadsheet_decoder.dart';

/// Only used for admin purposes, should not be used in production
/// The page provides the possibility to upload pictures to the file storage
/// and link them in the database
class UploadImages extends StatefulWidget {
  /// Only for admin purposes
  UploadImages({Key key}) : super(key: key);

  @override
  _UploadImagesState createState() => _UploadImagesState();
}

class _UploadImagesState extends State<UploadImages> {
  var _progress = 0.0;

  @override
  Widget build(BuildContext context) {
    assert(!kReleaseMode);
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (context) => LoadData())),
            icon: const Icon(Icons.next_plan_outlined),
          ),
          title: const Text('Upload images, ADMINS ONLY')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              'This page allows you to upload images and the corresponding description '
              'and copyright information to the database.\n'
              'This page should only be used by developers.\n\n\n\n'
              'The images or the copyright information is not checked for correctness\n\n'
              'Always make sure the data provided is correct before uploading !\n\n'
              'The Data should be stored in the folder:\nres/data/images.zip',
              style: TextStyle(fontSize: 18),
            ),
            Column(
              children: [
                ElevatedButton.icon(
                    icon: const Icon(Icons.backup_rounded),
                    onPressed: _upload,
                    label: const Text('Upload Images')),
                const SizedBox(height: 15),
                LinearProgressIndicator(value: _progress),
                const SizedBox(height: 15),
                if (_progress == 1)
                  const Text('All Images are uploaded successfully'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _upload() async {
    setState(() => _progress = 0);
    await FirebaseAuth.instance.signInAnonymously();
    FirebaseStorage.instance.setMaxUploadRetryTime(const Duration(seconds: 1));
    final directory = Directory.systemTemp.createTempSync();
    print(directory.path);
    // Read the Zip file from disk. and decode the Zip file
    final bytes = await rootBundle.load('res/data/images.zip');
    final archive = ZipDecoder().decodeBytes(bytes.buffer.asUint8List());
    // Extract the contents of the Zip archive to disk.
    for (final file in archive) {
      final filename = file.name;
      if (file.isFile) {
        final data = file.content as List<int>;
        File(directory.path + '/' + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(directory.path + '/' + filename).create(recursive: true);
      }
    }
    setState(() => _progress += 0.1);
    print('unzip done');
    print('read files from ${directory.path}');
    final files = directory.listSync(recursive: true, followLinks: false);
    for (final entity in files) {
      print('file looking at: ${entity.path}');

      /// Load images for Species
      if (entity.path.toLowerCase().contains('/artenphotos_copyright.xlsx')) {
        var file = File(entity.path);
        var excel = SpreadsheetDecoder.decodeBytes(file.readAsBytesSync());
        assert(excel.tables.keys.length == 1);
        final rows = excel.tables[excel.tables.keys.first].rows;
        // assert the columns are in the right order
        print(rows);
        assert(rows[0][0] == 'Filename');
        assert(rows[0][1] == 'Art');
        assert(rows[0][2] == 'Species');
        assert(rows[0][3] == 'Order');
        assert(rows[0][4] == 'Copyright');
        assert(rows[0][5] == 'Caption');
        for (final row in rows.skip(1)) {
          // Start with column 1, since column 0 is the filename
          final art = row[1] ?? '';
          final species = row[2] ?? 'species';
          final order = row[3].round() ?? '';
          final copyright = row[4] ?? '';
          final caption = row[5] ?? '';
          final photoRef =
              files.where((file) => file.path.contains('/${row[0]}')).first;
          final photo = File(photoRef.path);
          // upload image
          final task = await FirebaseStorage.instance
              .ref('species/$art-$order')
              .putFile(photo);
          // create reference in the database
          await FirebaseFirestore.instance
              .doc('imageReferences/$art-$order')
              .set({
            'copyright': copyright,
            'downloadURL': await task.ref.getDownloadURL(),
            'caption': caption,
            'order': order,
            'name': art,
            'type': species
          });
          setState(() => _progress += 0.3 / rows.length);
        }
      } else if (entity.path
          .toLowerCase()
          .contains('/lebensraumphotos_copyright.xlsx')) {
        /// Load images for Lebensräume / biodiversityMeasures
        var file = File(entity.path);
        var excel = SpreadsheetDecoder.decodeBytes(file.readAsBytesSync());
        assert(excel.tables.keys.length == 1);
        final rows = excel.tables[excel.tables.keys.first].rows;
        // assert the columns are in the right order
        assert(rows[0][0] == 'Filename');
        assert(rows[0][1] == 'Lebensraum');
        assert(rows[0][2] == 'Order');
        assert(rows[0][3] == 'Author');
        assert(rows[0][4] == 'Caption');
        for (final row in rows.skip(1)) {
          // Start with column 1, since column 0 is the filename
          final lebensraum = row[1] ?? '';
          final order = row[2].round();
          final copyright = row[3] ?? '';
          final caption = row[4] ?? '';
          final photoRef =
              files.where((file) => file.path.contains('/${row[0]}')).first;
          final photo = File(photoRef.path);

          // upload image
          final task = await FirebaseStorage.instance
              .ref('biodiversityMeasures/$lebensraum-$order')
              .putFile(photo);
          // create reference in the database
          await FirebaseFirestore.instance
              .doc('imageReferences/$lebensraum-$order')
              .set({
            'copyright': copyright,
            'downloadURL': await task.ref.getDownloadURL(),
            'caption': caption,
            'order': order,
            'name': lebensraum,
            'type': 'biodiversityElement'
          });
          setState(() => _progress += 0.3 / rows.length);
        }
      } else if (entity.path
          .toLowerCase()
          .contains('/stories_copyright.xlsx')) {
        /// Load images for Take home messages
        var file = File(entity.path);
        var excel = SpreadsheetDecoder.decodeBytes(file.readAsBytesSync());
        assert(excel.tables.keys.length == 1);
        final rows = excel.tables[excel.tables.keys.first].rows;
        // assert the columns are in the right order
        assert(rows[0][0] == 'Filename');
        assert(rows[0][1] == 'Keymessage');
        assert(rows[0][2] == 'Order');
        assert(rows[0][3] == 'Copyright');
        assert(rows[0][4] == 'Caption');
        for (final row in rows.skip(1)) {
          // Start with column 1, since column 0 is the filename
          final message = row[1] ?? '';
          final order = row[2].round();
          final copyright = row[3] ?? '';
          final caption = row[4] ?? '';
          final photoRef =
              files.where((file) => file.path.contains('/${row[0]}')).first;
          final photo = File(photoRef.path);


          // upload image
          final task = await FirebaseStorage.instance
              .ref('takeHomeMessages/$message-$order')
              .putFile(photo);
          // create reference in the database
          await FirebaseFirestore.instance
              .doc('imageReferences/$message-$order')
              .set({
            'copyright': copyright,
            'downloadURL': await task.ref.getDownloadURL(),
            'caption': caption,
            'order': order,
            'name': message,
            'type': 'Take Home Message',
          });
          setState(() => _progress += 0.3 / rows.length);
        }
      }
    }
    setState(() => _progress = 1);
  }
}
