import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

/// Object which stores the elements at a given location
class AddressObject {
  /// the contained Elements at this location
  final Map<String, int> elements;

  /// the coordinates as [GeoPoint] of the Address
  final GeoPoint coordinates;

  /// the time and date the object was created
  final DateTime creationDate;

  /// the document reference where this address object is stored in the database
  DocumentReference reference;

  final StorageProvider _storage;

  /// creates a new AddressObject with the provided elements
  /// at the given location
  AddressObject(this.elements, this.coordinates,
      {this.reference, StorageProvider storageProvider})
      : creationDate = DateTime.now(),
        _storage = storageProvider ??= StorageProvider.instance;

  /// create a AddressObject form a database snapshot
  /// Only used to parse objects from the database
  AddressObject.fromSnapshot(DocumentSnapshot snapshot,
      {StorageProvider storageProvider})
      : _storage = storageProvider ??= StorageProvider.instance,
        reference = snapshot.reference,
        elements = snapshot.data().containsKey('elements')
            ? Map<String, int>.from(snapshot.data()['elements'] as Map)
            : {},
        coordinates = snapshot.data().containsKey('coordinates')
            ? (snapshot.data()['coordinates'] as GeoPoint)
            : const GeoPoint(0, 0),
        creationDate = snapshot.data().containsKey('creationDate')
            ? (snapshot.data()['creationDate'] as Timestamp).toDate()
            : DateTime.now();

  /// Save the object to the database
  /// If it's a new object an entry will be created
  /// If the objects exists the details will be overridden
  Future<void> saveAddressObject() async {
    if (reference == null) {
      final alreadyExisting = await _storage.database
          .collection('locations')
          .where('coordinates', isEqualTo: coordinates)
          .get();
      if (alreadyExisting.docs.isEmpty) {
        reference = await _storage.database
            .collection('locations')
            .add({'coordinates': coordinates});
      } else {
        reference = alreadyExisting.docs.first.reference;
      }
    }
    return _storage.database.doc(reference.path).set({
      'elements': elements,
      'coordinates': coordinates,
      'creationDate': creationDate,
    });
  }

  /// returns a [LatLng] object of the coordinates. Used for google Maps
  LatLng getLatLng() {
    return LatLng(coordinates.latitude, coordinates.longitude);
  }

  /// returns all elements present at this location
  Future<List<BiodiversityMeasure>> getElements() async {
    final collection = await _storage.database
        .collection('biodiversityMeasures')
        .where('name', whereIn: elements.keys.toList())
        .get();
    return collection.docs
        .map((snapshot) => BiodiversityMeasure.fromSnapshot(snapshot))
        .toList();
  }

  /// returns the amount of elements present at this location
  int getCount(String measure) {
    if (elements.containsKey(measure)) {
      return elements[measure];
    } else {
      return 0;
    }
  }

  /// adds an element to this location.
  /// The changes will not be saved to the database automatically
  void addElement(String element, int amount) {
    elements.update(element, (old) => amount);
  }

  /// checks if the given [LatLng] object is at the same position
  bool isSameLocation(LatLng other) {
    return coordinates.latitude == other.latitude &&
        coordinates.longitude == other.longitude;
  }
}
