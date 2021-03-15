import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

/// Container class for the garden
class Garden {
  /// nickname of the garden
  String name;

  /// street and house number of the address of the garden
  String street;

  /// city the garden is in
  String city;
  int numberOfStructureElements;
  int numberOfPlants;
  int numberOfMethods;

  /// reference where the object is stored in the database
  final DocumentReference reference;

  /// which [BiodiversityMeasure] are contained in this garden,
  /// referenced by name
  Map<String, int> ownedObjects;

  /// create a new garden
  Garden(
      this.name,
      this.street,
      this.city,
      this.numberOfStructureElements,
      this.numberOfMethods,
      this.numberOfPlants,
      this.reference,
      this.ownedObjects);

  /// creates a Garden from the provided Map.
  /// Used for database loading and testing
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

  /// loads a garden form a database snapshot
  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// saves a specific detail to the database
  /// this method will fail if the garden does not exist in the database
  void saveGardenDetail(String field, dynamic value) {
    FirebaseFirestore.instance.doc(reference.id).update({field: value});
  }

  /// saves the garden object to the database
  /// any information already present on the database will be overridden
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

  /// removes a element from the garden
  void removeFromOwnedObjects(String object) {
    if (ownedObjects.containsKey(object)) {
      ownedObjects.remove(object);
    }
  }
}
