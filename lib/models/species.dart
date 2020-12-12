import 'package:cloud_firestore/cloud_firestore.dart';

class Species {
  final String name;
  final String short;
  final String description;
  final String tips;
  final String links;
  final String type;
  final Map<String, bool> _supportedBy;
  final String imageSource;
  final DocumentReference reference;

  Species(
    this.name,
    this.short,
    this.description,
    this.tips,
    this.links,
    this.type,
    this._supportedBy,
    this.reference,
    this.imageSource,
  );

  Species.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        short = map.containsKey('short') ? map['short'] as String : "",
        description =
            map.containsKey('description') ? map['description'] as String : "",
        tips = map.containsKey('tips')
            ? map['tips'] as String
            : "",
        links = map.containsKey('links')
            ? map['links'] as String
            : "",
      type = map.containsKey('type') ? map['type'] as String : "",
        _supportedBy = map.containsKey('supportedBy')
            ? Map<String, bool>.from(map['supportedBy'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
            map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    _supportedBy.removeWhere((key, value) => !value);
  }

  Species.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  String supportedBy() {
    final StringBuffer string = StringBuffer("(");
    for (final String s in _supportedBy.keys) {
      string.write("$s, ");
    }
    final String s = string.toString();
    if (s.length > 1) {
      return "${s.substring(0, s.length - 2)})";
    } else {
      return "nichts";
    }
  }
}
