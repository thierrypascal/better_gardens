import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  Set<DocumentReference> _gardens;
  Set<String> _favoredObjects;
  DocumentReference _reference;
  DocumentReference _addressID;
  UserCredential _credential;
  String nickname;
  String name;
  String surname;
  String phone;

  User.empty()
      : _reference = null,
        _gardens = <DocumentReference>{},
        _favoredObjects = <String>{},
        _addressID = null,
        _credential = null,
        nickname = "",
        name = "",
        surname = "",
        phone = "";

  User.fromMap(Map<String, dynamic> map, this._reference)
      : nickname = map.containsKey('nickname') ? map['nickname'] as String : "",
        name = map.containsKey('name') ? map['name'] as String : "",
        surname = map.containsKey('surname') ? map['surname'] as String : "",
        _addressID = map.containsKey('addressID')
            ? map['addressID'] as DocumentReference
            : null,
        phone = map.containsKey('phone') ? map['phone'] as String : "",
        _gardens = map.containsKey('gardens')
            ? Set<DocumentReference>.from(map['gardens'] as List)
            : <DocumentReference>{},
        _favoredObjects = map.containsKey('favoredObjects')
            ? Set.from(map['favoredObjects'] as List)
            : <String>{};

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.reference);

  Future<void> saveUser() async {
    _reference ??= await FirebaseFirestore.instance
        .collection('users')
        .add({'nickname': 'temp'});

    return FirebaseFirestore.instance.doc(_reference.path).set({
      'nickname': nickname,
      'name': name,
      'surname': surname,
      'addressID': _addressID,
      'phone': phone,
      'gardens': _gardens.toList(),
      'favoredObjects': _favoredObjects.toList(),
    });
  }

  void likeUnlikeElement(String element) {
    if (_favoredObjects.contains(element)) {
      _favoredObjects.remove(element);
    } else {
      _favoredObjects.add(element);
    }
    notifyListeners();
    saveUser();
  }

  bool doesLikeElement(String element) {
    return _favoredObjects.contains(element);
  }

  @override
  String toString() {
    return "{Nickname: $nickname, Name: $name, Surname: $surname, Reference: $_reference}";
  }

  static Future<User> loadUser(String path) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.doc(path).get();
    return User.fromSnapshot(snapshot);
  }
}
