
import 'package:cloud_firestore/cloud_firestore.dart';

class BiodiversityMeasure {
  final String name;
  final String description;
  final String buildInstructions;
  final String type;
  final Map<String, bool> beneficialFor;
  final Map<String, bool> badFor;
  final String imageSource;
  final DocumentReference reference;

  BiodiversityMeasure(this.name, this.description, this.buildInstructions,
      this.type, this.beneficialFor, this.reference, this.imageSource, this.badFor);

  BiodiversityMeasure.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        description =
            map.containsKey('description') ? map['description'] as String : "",
        buildInstructions = map.containsKey('buildInstructions')
            ? map['buildInstructions'] as String
            : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        beneficialFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        badFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
            map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    beneficialFor.removeWhere((key, value) => !value);
    badFor.removeWhere((key, value) => value);
  }

  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);
}
