import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:uuid/uuid.dart';

/// Container class for the garden
class Garden extends ChangeNotifier {
  /// nickname of the garden
  String name;

  /// street and house number of the address of the garden
  String street;

  /// Type of garden
  String gardenType;

  /// the coordinates as [GeoPoint] of the Address
  GeoPoint coordinates;

  /// the time and date the object was created
  DateTime creationDate;

  /// reference where the object is stored in the database
  DocumentReference reference;

  /// which [BiodiversityMeasure] are contained in this garden
  Map<String, int> ownedObjects;

  /// reference to the associated User
  String owner;

  ///image URL for the image of the garden
  String imageURL;

  bool _isEmpty;

  final StorageProvider _storage;

  /// creates an empty garden as placeholder
  Garden.empty({StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance {
    name = '';
    street = '';
    owner = '';
    gardenType = '';
    gardenType = '';
    ownedObjects = {};
    ownedLinkingProjects = [];
    coordinates = const GeoPoint(0, 0);
    creationDate = DateTime.now();
    _isEmpty = true;
    imageURL = '';
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
      garden.owner = gardens.first.owner;
      garden.ownedObjects.addAll(gardens.first.ownedObjects);
      garden.gardenType = gardens.first.gardenType;
      garden.ownedLinkingProjects.addAll(gardens.first.ownedLinkingProjects);
      garden._isEmpty = gardens.first._isEmpty;
      garden.reference = gardens.first.reference;
      garden.coordinates = gardens.first.coordinates;
      garden.imageURL = gardens.first.imageURL;
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
        street = map.containsKey('street') ? map['street'] as String : '',
        owner = map.containsKey('owner') ? map['owner'] as String : '',
        gardenType =
            map.containsKey('gardenType') ? map['gardenType'] as String : '',
        ownedObjects = map.containsKey('ownedObjects')
            ? Map<String, int>.from(map['ownedObjects'] as Map)
            : {},
        ownedLinkingProjects = map.containsKey('ownedLinkingProjects')
            ? List<String>.from(map['ownedLinkingProjects'] as Iterable)
            : [],
        coordinates = map.containsKey('coordinates')
            ? (map['coordinates'] as GeoPoint)
            : const GeoPoint(0, 0),
        creationDate = map.containsKey('creationDate')
            ? (map['creationDate'] as Timestamp).toDate()
            : DateTime.now(),
        imageURL = map.containsKey('imageURL') ? map['imageURL'] as String : '',
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
      'ownedObjects': ownedObjects,
      'coordinates': coordinates,
      'creationDate': creationDate,
      'ownedLinkingProjects': ownedLinkingProjects,
      'imageURL': imageURL,
    });
  }
 

  /// fucntion to load the details from the first garden of a user
  void switchGardenFromUser(User user) {}

  /// function to load the details of another garden
  void switchGarden(Garden garden) {
    name = garden.name;
    street = garden.street;
    owner = garden.owner;
    ownedObjects.clear();
    ownedObjects.addAll(garden.ownedObjects);
    ownedLinkingProjects.clear();
    ownedLinkingProjects.addAll(garden.ownedLinkingProjects);
    coordinates = garden.coordinates;
    gardenType = garden.gardenType;
    creationDate = garden.creationDate;
    reference = garden.reference;
    _isEmpty = garden._isEmpty;
    imageURL = garden.imageURL;
    notifyListeners();
  }

  /// adds an element with to a garden with the specified count
  /// and saves the garden to the database
  void addOwnedObject(String object, int count) {
    if (object != null && object.isNotEmpty && count > 0) {
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

  /// returns a [LatLng] object of the coordinates. Used for google Maps
  LatLng getLatLng() {
    return LatLng(coordinates.latitude, coordinates.longitude);
  }

  int _countAreaObjects(String dimension) {
    final elementList = ServiceProvider.instance.biodiversityService
        .getBiodiversityObjectList(dimension);
    List<BiodiversityMeasure> areaElements = [];
    int result = 0;

    elementList.forEach((element) {
      if (ownedObjects.keys.contains(element.name)) {
        areaElements.add(element);
      }
    });

    areaElements.forEach((element) {
      result += ownedObjects[element.name];
    });

    return result;
  }

  /// returns the nickname of the garden owner if showGardenOnMap is set to true for this user
  Future<bool> isShowImageOnGarden() async {
    final doc = await _storage.database.doc('users/$owner').get();
    if (doc != null && doc.exists) {
      final data = doc.data();
      if (data.containsKey('showGardenImageOnMap')) {
        final showImage = data['showGardenImageOnMap'] as bool;
        return showImage ? doc.data()['showGardenImageOnMap'] : false;
      }
    }
    return false;
  }


  int _countPointObjects(String dimension) {
    final elementList = ServiceProvider.instance.biodiversityService
        .getBiodiversityObjectList(dimension);
    List<BiodiversityMeasure> areaElements = [];
    int result = 0;

    elementList.forEach((element) {
      if (ownedObjects.keys.contains(element.name)) {
        areaElements.add(element);
      }
    });

    areaElements.forEach((element) {
      result += ownedObjects[element.name];
    });

    return result;
  }

  int _countLenghtObjects(String dimension) {
    final elementList = ServiceProvider.instance.biodiversityService
        .getBiodiversityObjectList(dimension);
    List<BiodiversityMeasure> areaElements = [];
    int result = 0;

    elementList.forEach((element) {
      if (ownedObjects.keys.contains(element.name)) {
        areaElements.add(element);
      }
    });

    areaElements.forEach((element) {
      result += ownedObjects[element.name];
    });

    return result;
  }

  int _countSupportedSpeciesObjects() {
    final elementList = ServiceProvider.instance.biodiversityService
        .getFullBiodiversityObjectList();
    List<BiodiversityMeasure> areaElements = [];
    int result = 0;

    elementList.forEach((element) {
      if (ownedObjects.keys.contains(element.name)) {
        areaElements.add(element);
      }
    });

    areaElements.forEach((element) {
      result += element.beneficialFor.length;
    });

    return result;
  }

  /// count of area objects
  int get totalAreaObjects => _countAreaObjects('Fläche');

  /// count of point objects
  int get totalPointObjects => _countPointObjects('Punkt');

  /// count of point objects
  int get totalLengthObjects => _countLenghtObjects('Linie');

  /// count of point objects
  int get totalSupportedSpecies => _countSupportedSpeciesObjects();

  /// is true if this garden is an empty placeholder
  bool get isEmpty => _isEmpty;
}
