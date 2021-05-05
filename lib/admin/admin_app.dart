import 'package:biodiversity/admin/upload_images.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(AdminApp());
}

/// Overview for all admin related tasks
//ignore: use_key_in_widget_constructors
class AdminApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(home: UploadImages());
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
