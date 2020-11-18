import 'dart:convert';
import 'dart:core';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as developer;

class Garden {
  String name;
  String street;
  String city;
  int numberOfStructureElements;
  int numberOfPlants;
  int numberOfMethods;
  DocumentReference reference;
  Map<String, int> ownedObjects;

  Garden(this.name, this.street, this.city, this.numberOfStructureElements,
      this.numberOfMethods, this.numberOfPlants);

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
        numberOfStructureElements = map['numberOfStructureElements'],
        numberOfPlants = map['numberOfPlants'],
        numberOfMethods = map['numberOfMethods'],
        ownedObjects = Map<String, int>.from(map['ownedObjects']);

  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  saveGardenDetail(String field, var value) {
    Firestore.instance
        .document(reference.documentID)
        .updateData({field: value});
  }

  Future<void> saveGarden() async {
    developer.log('Start save with path ${reference.path} id ${reference.documentID}');
    developer.log(ownedObjects.toString());
    return Firestore.instance.document(reference.path).setData({
      'name': name,
      'street': street,
      'city': city,
      'numberOfPlants': numberOfPlants,
      'numberOfMethods': numberOfMethods,
      'numberOfStructureElements': numberOfStructureElements,
      'ownedObjects': ownedObjects,
    });
  }

  void removeFromOwnedObjects(String object){
    if(ownedObjects.containsKey(object)) {
      ownedObjects.remove(object);
    }else{
      throw Exception("Object is not owned");
    }
  }
}
