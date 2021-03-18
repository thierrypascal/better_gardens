import 'dart:core';

import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Container class for the garden
//TODO change garden to a useful object
class Garden extends ChangeNotifier {
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
  DocumentReference reference;

  /// which [BiodiversityMeasure] are contained in this garden,
  /// referenced by name
  Map<String, int> ownedObjects;

  final StorageProvider _storage;

  /// creates an empty garden as placeholder
  Garden.empty(this._storage) {
    name = '';
    street = '';
    city = '';
  }

  /// create a new garden
  Garden(
      this.name,
      this.street,
      this.city,
      this.numberOfStructureElements,
      this.numberOfMethods,
      this.numberOfPlants,
      this.ownedObjects,
      this._storage);

  /// creates a Garden from the provided Map.
  /// Used for database loading and testing
  Garden.fromMap(Map<String, dynamic> map, this._storage, {this.reference})
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
  Garden.fromSnapshot(DocumentSnapshot snapshot, StorageProvider storage)
      : this.fromMap(snapshot.data(), storage, reference: snapshot.reference);

  /// saves a specific detail to the database
  /// this method will fail if the garden does not exist in the database
  void saveGardenDetail(String field, dynamic value) {
    _storage.database.doc(reference.id).update({field: value});
  }

  /// saves the garden object to the database
  /// any information already present on the database will be overridden
  Future<void> saveGarden() async {
    return _storage.database.doc(reference.path).set({
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
