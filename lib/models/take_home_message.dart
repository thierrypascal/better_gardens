import 'package:biodiversity/models/information_object.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';

/// A container class of a take home message.
class TakeHomeMessage implements InformationObject {
  @override
  final String name;

  @override
  String description;

  @override
  String shortDescription;

  @override
  String get type => 'Take Home Message';

  @override
  String get category => 'Take Home Message';

  /// how long the message takes to read
  final String readTime;

  /// the reference to the location in the database
  final DocumentReference reference;

  final StorageProvider _storage;

  /// creates a [TakeHomeMessage] from the provided map
  /// used to load elements from the database and for testing
  TakeHomeMessage.fromMap(Map<String, dynamic> map,
      {this.reference, StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        name = map.containsKey('title') ? map['title'] as String : '',
        readTime = map.containsKey('readTime') ? map['readTime'] as String : '',
        description = '',
        shortDescription = '' {
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    try {
      description = await _storage
          .getTextFromFileStorage('/takeHomeMessages/body/$name.md');
    } on PlatformException {
      description = 'Fehler: keine Beschreibung gefunden.';
    }

    var pointIndex = description.indexOf('\.', 400);
    if (pointIndex == -1) pointIndex = 400;
    shortDescription = '${description.substring(0, pointIndex)}.';
  }

  /// load a [TakeHomeMessage] form a database snapshot
  TakeHomeMessage.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  @override
  // no linked items
  Map<String, Iterable<InformationObject>> get associationMap => {};
}
