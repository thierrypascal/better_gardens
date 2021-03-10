import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A container class of a take home message.
class TakeHomeMessage {
  /// name of the element e.g. meadow
  final String title;

  /// a description of the element
  String description;

  /// the reference to the location in the database
  final DocumentReference reference;

  final _storage = FirebaseStorage.instance;
  final _descriptionPath = "takeHomeMessage/body/";

  /// creates a [TakeHomeMessage] from the provided map
  /// used to load elements from the database and for testing
  TakeHomeMessage.fromMap(Map<String, dynamic> map, {this.reference})
      : title = map.containsKey('title') ? map['title'] as String : "" {
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    final folder = await _storage.ref(_descriptionPath).listAll();
    if (folder.items.contains("$title.md")) {
      final data = await _storage
          .ref("takeHomeMessage/body/$title.md")
          .getData();
      description = Utf8Decoder().convert(data);
    }
  }

  /// load a [TakeHomeMessage] form a database snapshot
  TakeHomeMessage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

}
