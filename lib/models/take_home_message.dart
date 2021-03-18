import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';

/// A container class of a take home message.
class TakeHomeMessage {
  /// name of the element e.g. meadow
  final String title;

  /// a description of the element
  String description;

  /// a short description extracted from the description
  String shortDescription;

  /// a reference to the image
  final String imageSource;

  /// how long the message takes to read
  final String readTime;

  /// the reference to the location in the database
  final DocumentReference reference;

  final _storage = FirebaseStorage.instance;
  final _descriptionPath = 'takeHomeMessages/body/';

  /// creates a [TakeHomeMessage] from the provided map
  /// used to load elements from the database and for testing
  TakeHomeMessage.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map.containsKey('title') ? map['title'] as String : '',
        readTime = map.containsKey('readTime') ? map['readTime'] as String : '',
        imageSource =
            map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    try {
      final data = await _storage
          .ref()
          .child('takeHomeMessages/body/$title.md')
          .getData(1024 * 1024);
      description = const Utf8Decoder().convert(data);
    } on PlatformException {
      description = 'Fehler: keine Beschreibung gefunden.';
    }

    //TODO: make a nicer shortDescription
    shortDescription = '${description.substring(0, 400)}...';
  }

  /// load a [TakeHomeMessage] form a database snapshot
  TakeHomeMessage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
