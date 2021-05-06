import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/services/service_provider.dart';
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

  /// Type of garden
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

  bool _isEmpty;
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
    _isEmpty = true;
  }

  /// creates a garden from the garden which is assigned to the user
  factory Garden.fromUser(User user, {StorageProvider storageProvider}) {
    final gardens =
        ServiceProvider.instance.gardenService.getAllGardensFromUser(user);
    if (gardens.isEmpty) {
      return Garden.empty(storageProvider: storageProvider);
    } else {
      final garden = Garden.empty(storageProvider: storageProvider);
      garden.name = gardens.first.name;
      garden.street = gardens.first.street;
      garden.city = gardens.first.city;
      garden.owner = gardens.first.owner;
      garden.gardenType = gardens.first.gardenType;
      garden.ownedObjects = gardens.first.ownedObjects;
      garden.ownedLinkingProjects = gardens.first.ownedLinkingProjects;
      garden._isEmpty = gardens.first._isEmpty;
      garden.reference = gardens.first.reference;
      return garden;
    }
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
            : [],
        _isEmpty = false;

  /// loads a garden form a database snapshot
  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  /// saves the garden object to the database
  /// any information already present on the database will be overridden
  Future<void> saveGarden() async {
    if (_isEmpty || reference == null) {
      reference = _storage.database.doc('gardens/${const Uuid().v4()}');
      _isEmpty = false;
    }
    final path = reference.path;
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

  /// fucntion to load the details from the first garden of a user
  void switchGardenFromUser(User user) {}

  /// function to load the details of another garden
  void switchGarden(Garden garden) {
    name = garden.name;
    street = garden.street;
    city = garden.city;
    owner = garden.owner;
    ownedObjects.clear();
    ownedObjects.addAll(garden.ownedObjects);
    ownedLinkingProjects.clear();
    ownedLinkingProjects.addAll(garden.ownedLinkingProjects);
    _isEmpty = garden._isEmpty;
    notifyListeners();
  }

  /// adds an element with to a garden with the specified count
  /// and saves the garden to the database
  void addOwnedObject(String object, int count) {
    if (object != null &&
        object.isNotEmpty &&
        count > 0 ) {
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

  /// is true if this garden is an empty placeholder
  bool get isEmpty => _isEmpty;
}
