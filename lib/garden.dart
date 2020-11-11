import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class Garden{
  String name;
  String street;
  String city;
  DocumentReference reference;

  Garden(this.name, this.street, this.city);

  Garden.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['name'] != null),
        assert(map['city'] != null),
        assert(map['street'] != null),
        name = map['name'] as String,
        city = map['city'] as String,
        street = map['street'] as String;

  Garden.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

}