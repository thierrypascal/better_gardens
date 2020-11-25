import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';

class MapIcon {
  String type;
  String element;
  DateTime creationDate;
  DocumentReference reference;

  MapIcon(
      this.type,
      this.element,
      this.creationDate,
      this.reference);

  MapIcon.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['type'] != null),
        assert(map['element'] != null),
        assert(map['creationDate'] != null),
        type = map['type'] as String,
        element = map['element'] as String,
        creationDate = map['creationDate'] as DateTime;

  MapIcon.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), reference: snapshot.reference);

  void saveMapIconDetail(String field, dynamic value) {
    FirebaseFirestore.instance.doc(reference.id).update({field: value});
  }

  Future<void> saveMapIcon() async {
    return FirebaseFirestore.instance.doc(reference.path).set({
      'type': type,
      'element': element,
      'creationDate': creationDate,
    });
  }
}
