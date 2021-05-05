import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';

/// Container class for the garden
class Garden extends ChangeNotifier {
  /// nickname of the garden
  String name;

  /// street and house number of the address of the garden
  String street;

  /// city the garden is in
  String city;

  //Type of garden
  String gardenType;

  /// latitude coordinates of garden placement on map
  double latitude;

  /// longitude coordinates of garden placement on map
  double longitude;

  /// reference where the object is stored in the database
  DocumentReference reference;

  /// which [BiodiversityMeasure] are contained in this garden
  Map<String, int> ownedObjects;

  /// reference to the associated User
  String owner;

  final StorageProvider _storage;

  /// creates an empty garden as placeholder
  Garden.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance {
    name = '';
    street = '';
    city = '';
    owner = '';
    gardenType = '';
    ownedObjects = {};
    ownedLinkingProjects = [];
  }

  /// which [Vernetzungsprojekte] are contained in this garden
  //TODO: Implement Vernetzungsprojekte and switch String to Vernetzungsprojekt
  List<String> ownedLinkingProjects;

  /// creates a Garden from the provided Map.
  /// Used for database loading and testing
  Garden.fromMap(Map<String, dynamic> map,
      {this.reference, StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        name = map.containsKey('name') ? map['name'] as String : '',
        city = map.containsKey('city') ? map['city'] as String : '',
        street = map.containsKey('street') ? map['street'] as String : '',
        owner = map.containsKey('owner') ? map['owner'] as String : '',
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
            ? List<String>.from(map['ownedLinkingProjects'] as Iterable)
            : [];

  /// loads a garden form a database snapshot
  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// saves the garden object to the database
  /// any information already present on the database will be overridden
  Future<void> saveGarden() async {
    final path =
        reference == null ? 'gardens/${const Uuid().v4()}' : reference.path;
    await _storage.database.doc(path).set({
      'owner': owner,
      'name': name,
      'street': street,
      'gardenType': gardenType,
      'city': city,
      'latitude': latitude,
      'longitude': longitude,
      'ownedObjects': ownedObjects,
      'ownedLinkingProjects': ownedLinkingProjects,
    });
  }

  /// adds an element with to a garden with the specified count
  /// and saves the garden to the database
  void addOwnedObject(String object, int count) {
    if (object != null &&
        object.isNotEmpty &&
        count > 0 &&
        !ownedObjects.containsKey(object)) {
      ownedObjects[object] = count;
      saveGarden();
    }
  }

  /// add a LinkingProject to the garden
  /// and saves the garden to the database
  void addLinkingProject(String linkingProject) {
    if (linkingProject != null &&
        linkingProject.isNotEmpty &&
        !ownedLinkingProjects.contains(linkingProject)) {
      ownedLinkingProjects.add(linkingProject);
      saveGarden();
    }
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
      ownedLinkingProjects.remove(object);
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

