import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Garden {
  String name;
  String street;
  String city;
  int numberOfStructureElements;
  int numberOfPlants;
  int numberOfMethods;
  DocumentReference reference;

  Garden(this.name, this.street, this.city, this.numberOfStructureElements,
      this.numberOfMethods, this.numberOfPlants);

  Garden.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['city'] != null),
        assert(map['street'] != null),
        assert(map['numberOfStructureElements'] != null),
        assert(map['numberOfPlants'] != null),
        assert(map['numberOfMethods'] != null),
        name = map['name'] as String,
        city = map['city'] as String,
        street = map['street'] as String,
        numberOfStructureElements = map['numberOfStructureElements'],
        numberOfPlants = map['numberOfPlants'],
        numberOfMethods = map['numberOfMethods'];

  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  saveGardenDetail(String field, var value) {
    Firestore.instance.document(reference.documentID).updateData({field:value});
  }

  saveGarden(){
    print('Start save');
    Firestore.instance.document(reference.documentID).setData({
      'name': name,
      'street': street,
      'city': city,
      'numberOfPlants': numberOfPlants,
      'numberOfMethods': numberOfMethods,
      'numberOfStructureElements':numberOfStructureElements,
    }).then((value) => print('garden saved'));
  }
}
