import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Garden {
  String name;
  String street;
  String city;
  int numberOfStructureElements;
  int numberOfPlants;
  int numberOfMethods;
  final DocumentReference reference;
  Map<String, int> ownedObjects;

  Garden(
      this.name,
      this.street,
      this.city,
      this.numberOfStructureElements,
      this.numberOfMethods,
      this.numberOfPlants,
      this.reference,
      this.ownedObjects);

  Garden.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['city'] != null),
        assert(map['street'] != null),
        assert(map['numberOfStructureElements'] != null),
        assert(map['numberOfPlants'] != null),
        assert(map['numberOfMethods'] != null),
        assert(map['ownedObjects'] != null),
        name = map['name'] as String,
        city = map['city'] as String,
        street = map['street'] as String,
        numberOfStructureElements = map['numberOfStructureElements'] as int,
        numberOfPlants = map['numberOfPlants'] as int,
        numberOfMethods = map['numberOfMethods'] as int,
        ownedObjects = Map<String, int>.from(map['ownedObjects'] as Map);

  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  void saveGardenDetail(String field, dynamic value) {
    FirebaseFirestore.instance.doc(reference.id).update({field: value});
  }

  Future<void> saveGarden() async {
    return FirebaseFirestore.instance.doc(reference.path).set({
      'name': name,
      'street': street,
      'city': city,
      'numberOfPlants': numberOfPlants,
      'numberOfMethods': numberOfMethods,
      'numberOfStructureElements': numberOfStructureElements,
      'ownedObjects': ownedObjects,
    });
  }

  void removeFromOwnedObjects(String object) {
    if (ownedObjects.containsKey(object)) {
      ownedObjects.remove(object);
    } else {
      throw Exception("Object is not owned");
    }
  }
}
