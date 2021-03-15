import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

/// A container class of a Measure to improve biodiversity.
/// Example: A pile of branches
class BiodiversityMeasure {
  /// name of the element e.g. meadow
  final String name;

  /// a description of the element
  String description;

  /// a short description of the element
  final String shortDescription;

  /// which type the element belongs to e.g. Structure
  final String type;
  final List<String> _beneficialFor;

  /// All other measures which work well together with this measure
  final List<String> goodTogetherWith;

  /// a reference to the image
  final String imageSource;

  /// the reference to the location in the database
  final DocumentReference reference;

  final _storage = FirebaseStorage.instance;
  final _descriptionPath = "biodiversityMeasures/descriptions/";

  /// creates a [BiodiversityMeasure] from the provided map
  /// used to load elements from the database and for testing
  BiodiversityMeasure.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        shortDescription = map.containsKey('shortDescription')
            ? map['shortDescription'] as String
            : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        _beneficialFor = map.containsKey('beneficialFor')
            ? map['beneficialFor'].cast<String>()
            : [],
        goodTogetherWith = map.containsKey('goodTogetherWith')
            ? map['goodTogetherWith'].cast<String>()
            : [],
        imageSource =
            map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    _loadDescription();
  }

  Future<void> _loadDescription() async {
    try{
      final data = await _storage.ref().child("takeHomeMessages/body/$name.md").getData(1024*1024);
      description = Utf8Decoder().convert(data);
    }catch(e){
      description = "Fehler: keine Beschreibung gefunden.";
    }
  }

  /// load a [BiodiversityMeasure] form a database snapshot
  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// returns a formatted string which holds all species
  /// which this element is good for
  String get beneficialFor => _getCommaSeparatedString(_beneficialFor);

  String _getCommaSeparatedString(Iterable<String> elements) {
    final string = StringBuffer();
    for (final s in elements) {
      string.write("$s, ");
    }
    final s = string.toString();
    if (s.length > 1) {
      return s.substring(0, s.length - 2);
    } else {
      return "nichts";
    }
  }
}
