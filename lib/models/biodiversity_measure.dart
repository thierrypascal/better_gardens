import 'package:cloud_firestore/cloud_firestore.dart';

class BiodiversityMeasure {
  /// name of the element e.g. meadow
  final String name;

  /// a short description of the element
  final String description;

  /// a detailed description on how to build the element
  final String buildInstructions;

  /// which type the element belongs to e.g. Structure
  final String type;
  final Map<String, bool> _beneficialFor;
  final Map<String, bool> _badFor;

  /// a reference to the image
  final String imageSource;

  /// the reference to the location in the database
  final DocumentReference reference;

  /// create a new [BiodiversityMeasure]
  BiodiversityMeasure(
      this.name,
      this.description,
      this.buildInstructions,
      this.type,
      this._beneficialFor,
      this.reference,
      this.imageSource,
      this._badFor);

  /// creates a [BiodiversityMeasure] from the provided map
  /// used to load elements from the database and for testing
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

  /// load a [BiodiversityMeasure] form a database snapshot
  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// returns a formatted string which holds all species
  /// which this element is good for
  String get beneficialFor => _buildString(_beneficialFor.keys);

  /// returns a formatted string which holds all species
  /// which this element is bad for
  String get badFor => _buildString(_badFor.keys);

  String _buildString(Iterable<String> elements) {
    final string = StringBuffer("(");
    for (final s in elements) {
      string.write("$s, ");
    }
    final s = string.toString();
    if (s.length > 1) {
      return "${s.substring(0, s.length - 2)})";
    } else {
      return "nichts";
    }
  }
}
