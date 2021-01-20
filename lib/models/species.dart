import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

/// Container class for a species
class Species {
  /// name of the specie e.g. Hedgehog
  final String name;

  /// short description of the species
  final String short;

  /// detailed description of the species
  final String description;

  /// tips on how to support the species
  final String tips;

  /// links to further information
  final String links;

  /// type of the species e.g. Säugetiere
  final String type;
  final Map<String, bool> _supportedBy;

  /// reference to a image of the species
  final String imageSource;

  /// reference to the store location in the database
  final DocumentReference reference;

  /// create a new empty species. Should not be used in production,
  /// since all Species are loaded from the database
  //TODO remove this maybe ?
  Species(this.name,
      this.short,
      this.description,
      this.tips,
      this.links,
      this.type,
      this._supportedBy,
      this.reference,
      this.imageSource,);

  /// creates a Species object from a Map
  Species.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        short = map.containsKey('short') ? map['short'] as String : "",
        description =
            map.containsKey('description') ? map['description'] as String : "",
        tips = map.containsKey('tips') ? map['tips'] as String : "",
        links = map.containsKey('links') ? map['links'] as String : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        _supportedBy = map.containsKey('supportedBy')
            ? Map<String, bool>.from(map['supportedBy'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
            map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    _supportedBy.removeWhere((key, value) => !value);
  }

  /// creates a Species object from a database snapshot
  Species.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// returns a formatted string with the [BiodiversityMeasure]
  /// supporting the species
  String supportedBy() {
    final string = StringBuffer("(");
    for (final s in _supportedBy.keys) {
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
