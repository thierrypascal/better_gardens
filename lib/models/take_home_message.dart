import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

/// A container class of a take home message.
class TakeHomeMessage {
  /// name of the element e.g. meadow
  final String title;

  /// a description of the element
  String description;

  /// a short description extracted from the description
  String shortDescription;

  /// how long the message takes to read
  final String readTime;

  /// the reference to the location in the database
  final DocumentReference reference;

  final StorageProvider _storage;

  /// creates a [TakeHomeMessage] from the provided map
  /// used to load elements from the database and for testing
  TakeHomeMessage.fromMap(Map<String, dynamic> map, StorageProvider storage,
      {this.reference})
      : _storage = storage,
        title = map.containsKey('title') ? map['title'] as String : '',
        readTime = map.containsKey('readTime') ? map['readTime'] as String : '',
        description = '',
        shortDescription = '' {
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    try {
      description = await _storage
          .getTextFromFileStorage('/takeHomeMessages/body/$title.md');
    } on PlatformException {
      description = 'Fehler: keine Beschreibung gefunden.';
    }

    var pointIndex = description.indexOf('\.', 400);
    if (pointIndex == -1) pointIndex = 400;
    shortDescription = '${description.substring(0, pointIndex)}.';
  }

  /// load a [TakeHomeMessage] form a database snapshot
  TakeHomeMessage.fromSnapshot(
      DocumentSnapshot snapshot, StorageProvider storageProvider)
      : this.fromMap(snapshot.data(), storageProvider,
            reference: snapshot.reference);
}
