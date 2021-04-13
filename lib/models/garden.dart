import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// Container class for the garden
class Garden extends ChangeNotifier {
  /// nickname of the garden
  String name;

  /// street and house number of the address of the garden
  String street;

  /// city the garden is in
  String city;

  /// latitude coordinates of garden placement on map
  double latitude;

  /// longitude coordinates of garden placement on map
  double longitude;

  /// reference where the object is stored in the database
  DocumentReference reference;

  /// which [BiodiversityMeasure] are contained in this garden
  Map<String, int> ownedObjects;

  /// reference to the associated User
  List<String> owner;

  final StorageProvider _storage;

  /// creates an empty garden as placeholder
  Garden.empty(this._storage) {
    name = '';
    street = '';
    city = '';
    owner = [];
    ownedObjects = {};
  }

  /// which [Vernetzungsprojekte] are contained in this garden
  //TODO: Implement Vernetzungsprojekte and switch String to Vernetzungsprojekt
  List<String> ownedLinkingProjects;

  /// create a new garden
  Garden(
      this.name,
      this.street,
      this.city,
      this.latitude,
      this.longitude,
      this.reference,
      this.ownedObjects,
      this.ownedLinkingProjects,
      this.owner,
      this._storage);

  /// creates a Garden from the provided Map.
  /// Used for database loading and testing
  Garden.fromMap(Map<String, dynamic> map, this._storage, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : '',
        city = map.containsKey('city') ? map['city'] as String : '',
        street = map.containsKey('street') ? map['street'] as String : '',
        latitude = map.containsKey('latitude')
            ? map['latitude'] as double
            // FIBL coordinates
            : 47.516957350645754,
        longitude = map.containsKey('longitude')
            ? map['longitude'] as double
            // FIBL coordinates
            : 8.025010981051828,
        ownedObjects = map.containsKey('ownedObjects')
            ? Map<String, int>.from(map['ownedObjects'] as Map)
            : {},
        ownedLinkingProjects = map.containsKey('ownedLinkingProjects')
            ? Map<String, int>.from(map['ownedLinkingProjects'] as Map)
            : {};

  /// loads a garden form a database snapshot
  Garden.fromSnapshot(DocumentSnapshot snapshot, StorageProvider storage)
      : this.fromMap(snapshot.data(), storage, reference: snapshot.reference);

  /// saves the garden object to the database
  /// any information already present on the database will be overridden
  Future<void> saveGarden() async {
    return _storage.database.doc(reference.path).set({
      'owner': owner,
      'name': name,
      'street': street,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'ownedObjects': ownedObjects,
      'ownedLinkingProjects': ownedLinkingProjects,
    });
  }

  /// removes a element from the garden, changes are saved automatically
  void removeFromOwnedObjects(String object) {
    if (ownedObjects.containsKey(object)) {
      ownedObjects.remove(object);
      saveGarden();
    }
  }

  /// removes a element from the garden, changes are saved automatically
  void removeFromLinkingProjects(String object) {
    if (ownedLinkingProjects.contains(object)) {
      ownedObjects.remove(object);
      saveGarden();
    }
  }

  int _countObjects(String type) {
    // TODO actually count the different objects
    return ownedObjects.length;
  }

  /// count of area objects
  int get totalAreaObjects => _countObjects('area');

  /// count of point objects
  int get totalPointObjects => _countObjects('point');

  /// count of point objects
  int get totalLengthObjects => _countObjects('length');

  /// count of point objects
  int get totalSupportedSpecies => _countObjects('species');
}
