import 'dart:core';

import 'package:biodiversity/models/biodiversity_measure.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AddressObject {
  final Map<String, int> elements;
  final GeoPoint coordinates;
  final DateTime creationDate;
  DocumentReference reference;

  AddressObject(this.creationDate, this.elements, this.coordinates,
      {this.reference});

  AddressObject.fromMap(Map<String, dynamic> map, this.reference)
      : elements = map.containsKey('elements')
            ? Map<String, int>.from(map['elements'] as Map)
            : {},
        coordinates = map.containsKey('coordinates')
            ? (map['coordinates'] as GeoPoint)
            : const GeoPoint(0, 0),
        creationDate = map.containsKey('creationDate')
            ? (map['creationDate'] as Timestamp).toDate()
            : DateTime.now();

  AddressObject.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.reference);

  Future<void> saveAddressObject() async {
    if (reference == null) {
      final QuerySnapshot alreadyExisting = await FirebaseFirestore.instance
          .collection('locations')
          .where('coordinates', isEqualTo: coordinates)
          .get();
      if (alreadyExisting.docs.isEmpty) {
        reference = await FirebaseFirestore.instance
            .collection('locations')
            .add({'coordinates': coordinates});
      } else {
        reference = alreadyExisting.docs.first.reference;
      }
    }
    return FirebaseFirestore.instance.doc(reference.path).set({
      'elements': elements,
      'coordinates': coordinates,
      'creationDate': creationDate,
    });
  }

  LatLng getLatLng() {
    return LatLng(coordinates.latitude, coordinates.longitude);
  }

  Future<List<BiodiversityMeasure>> getElements() async {
    final collection = await FirebaseFirestore.instance
        .collection('biodiversityMeasures')
        .where('name', whereIn: elements.keys.toList())
        .get();
    return collection.docs
        .map((snapshot) => BiodiversityMeasure.fromSnapshot(snapshot))
        .toList();
  }

  int getCount(String measure) {
    if (elements.containsKey(measure)) {
      return elements[measure];
    } else {
      return 0;
    }
  }

  void addElement(String element, int amount) {
    elements.putIfAbsent(element, () => amount);
  }
}
