import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Container class for a species
class Species {
  /// class of the specie e.g. Säugetier
  final String speciesClass;

  /// name of the specie e.g. Hedgehog
  final String name;

  /// short description of the species
  final String shortDescription;

  /// detailed description of the species
  final String description;

  /// other species which
  final List<String> _connectedTo;

  /// type of the species e.g. Säugetiere
  final String type;
  final List<String> _supportedBy;

  /// reference to the store location in the database
  final DocumentReference reference;

  /// reference to an imageSource of the species
  final String imageSource;

  /// creates a Species object from a Map
  Species.fromMap(Map<String, dynamic> map, {this.reference})
      : speciesClass = map.containsKey('class') ? map['class'] as String : "",
        name = map.containsKey('name') ? map['name'] as String : "",
        shortDescription = map.containsKey('shortDescription')
            ? map['shortDescription'] as String
            : "",
        imageSource = map.containsKey('imageSource')
            ? map['imageSource'] as String
            : "res/logo.png",
        description =
            map.containsKey('description') ? map['description'] as String : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        _connectedTo = map.containsKey('connectedTo')
            ? map['connectedTo'].cast<String>()
            : [],
        _supportedBy = map.containsKey('supportedBy')
            ? map['supportedBy'].cast<String>()
            : [];

  /// creates a Species object from a database snapshot
  Species.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// returns a formatted string with the [BiodiversityMeasure]
  /// supporting the species
  String supportedBy() => _getCommaSeparatedString(_supportedBy);

  /// returns a formatted string with other [Species]
  /// which go well together with this
  String connectedTo() => _getCommaSeparatedString(_connectedTo);

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
