import 'dart:core';
import 'dart:developer' as logging;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  Set<DocumentReference> _gardens;
  Set<String> _favoredObjects;
  DocumentReference _reference;
  DocumentReference _addressID;
  String nickname;
  String name;
  String surname;
  String passwordHash;
  String email;
  String phone;
  bool hasConfirmedEmail;

  User.empty()
      : _reference = null,
        _gardens = <DocumentReference>{},
        _favoredObjects = <String>{},
        _addressID = null,
        nickname = "",
        name = "",
        surname = "",
        passwordHash = "",
        email = "",
        phone = "",
        hasConfirmedEmail = false;

  User.fromMap(Map<String, dynamic> map, this._reference)
      : nickname = map.containsKey('nickname') ? map['nickname'] as String : "",
        name = map.containsKey('name') ? map['name'] as String : "",
        surname = map.containsKey('surname') ? map['surname'] as String : "",
        passwordHash = map.containsKey('passwordHash')
            ? map['passwordHash'] as String
            : "",
        _addressID = map.containsKey('addressID')
            ? map['addressID'] as DocumentReference
            : null,
        email = map.containsKey('email') ? map['email'] as String : "",
        phone = map.containsKey('phone') ? map['phone'] as String : "",
        _gardens = map.containsKey('gardens')
            ? Set<DocumentReference>.from(map['gardens'] as List)
            : <DocumentReference>{},
        _favoredObjects = map.containsKey('favoredObjects')
            ? Set.from(map['favoredObjects'] as List)
            : <String>{},
        hasConfirmedEmail = map.containsKey('hasConfirmedEmail') &&
            map['hasConfirmedEmail'] as bool {
    logging.log("fav len: ${_favoredObjects.length.toString()}");
  }

  User.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data(), snapshot.reference);

  Future<void> saveUser() async {
    if (_reference == null) {
      logging.log("reference is null");
      _reference = await FirebaseFirestore.instance
          .collection('users')
          .add({'nickname': 'temp'});
      logging.log("User added");
    }

    if (_reference == null) {
      logging.log("Not possible");
    }

    logging.log("Saving the User: $this");
    return FirebaseFirestore.instance.doc(_reference.path).set({
      'nickname': nickname,
      'name': name,
      'surname': surname,
      'passwordHash': passwordHash,
      'addressID': _addressID,
      'email': email,
      'phone': phone,
      'gardens': _gardens.toList(),
      'favoredObjects': _favoredObjects.toList(),
      'hasConfirmedEmail': hasConfirmedEmail,
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
    logging.log("Does like $element ? $this");
    return _favoredObjects.contains(element);
  }

  @override
  String toString() {
    return "{Nickname: $nickname, Name: $name, Surname: $surname, Email: $email, Reference: $_reference}";
  }

  static Future<User> loadUser(String path) async {
    final DocumentSnapshot snapshot =
        await FirebaseFirestore.instance.doc(path).get();
    return User.fromSnapshot(snapshot);
  }
}
