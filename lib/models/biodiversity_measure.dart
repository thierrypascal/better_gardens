import 'package:cloud_firestore/cloud_firestore.dart';

class BiodiversityMeasure {
  final String name;
  final String description;
  final String buildInstructions;
  final String type;
  final Map<String, bool> _beneficialFor;
  final Map<String, bool> _badFor;
  final String imageSource;
  final DocumentReference reference;

  BiodiversityMeasure(
      this.name,
      this.description,
      this.buildInstructions,
      this.type,
      this._beneficialFor,
      this.reference,
      this.imageSource,
      this._badFor);

  BiodiversityMeasure.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        description =
            map.containsKey('description') ? map['description'] as String : "",
        buildInstructions = map.containsKey('buildInstructions')
            ? map['buildInstructions'] as String
            : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        _beneficialFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        _badFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
        map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    _beneficialFor.removeWhere((key, value) => !value);
    _badFor.removeWhere((key, value) => value);
  }

  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  String beneficialFor() {
    final StringBuffer string = StringBuffer("(");
    for (final String s in _beneficialFor.keys) {
      string.write("$s, ");
    }
    String s = string.toString();
    if (s.length > 1) {
      return "${s.substring(0, s.length - 2)})";
    } else {
      return "nichts";
    }
  }

  String badFor() {
    final StringBuffer string = StringBuffer("(");
    for (final String s in _badFor.keys) {
      string.write("$s, ");
    }
    String s = string.toString();
    if (s.length > 1) {
      return "${s.substring(0, s.length - 2)})";
    } else {
      return "nichts";
    }
  }
}
