import 'dart:core';
import 'dart:developer' as logging;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  Set<DocumentReference> _gardens;
  Set<String> _favoredObjects;
  DocumentReference _addressID;
  String nickname;
  String name;
  String surname;
  String phone;

  User.empty()
      : _gardens = <DocumentReference>{},
        _favoredObjects = <String>{},
        _addressID = null,
        nickname = "",
        name = "",
        surname = "",
        phone = "" {
    firebase_auth.FirebaseAuth.instance.userChanges().listen((event) {
      loadDetailsFromLoggedInUser();
    });
    loadDetailsFromLoggedInUser();
  }

  Future<bool> loadDetailsFromLoggedInUser() async {
    logging.log("load details");
    if (!isLoggedIn()) {
      return false;
    }
    final doc = await FirebaseFirestore.instance.doc(documentPath).get();
    if (!doc.exists) {
      logging.log("Loading failed, no doc found");
      return false;
    }
    final Map<String, dynamic> map = doc.data();
    nickname = map.containsKey('nickname') ? map['nickname'] as String : "";
    name = map.containsKey('name') ? map['name'] as String : "";
    surname = map.containsKey('surname') ? map['surname'] as String : "";
    _addressID = map.containsKey('addressID')
        ? map['addressID'] as DocumentReference
        : null;
    phone = map.containsKey('phone') ? map['phone'] as String : "";
    _gardens = map.containsKey('gardens')
        ? Set<DocumentReference>.from(map['gardens'] as List)
        : <DocumentReference>{};
    _favoredObjects = map.containsKey('favoredObjects')
        ? Set.from(map['favoredObjects'] as List)
        : <String>{};
    notifyListeners();
    return true;
  }

  Future<bool> saveUser() async {
    if (!isLoggedIn()) {
      return false;
    }
    await FirebaseFirestore.instance.doc(documentPath).set({
      'nickname': nickname,
      'name': name,
      'surname': surname,
      'addressID': _addressID,
      'phone': phone,
      'gardens': _gardens.toList(),
      'favoredObjects': _favoredObjects.toList(),
    });
    return true;
  }

  void updateUserData(
      {String newName,
      String newSurname,
      String newNickname,
      String newPhone,
      String newAddress}) {
    if (newName != null) name = newName;
    if (newSurname != null) surname = newSurname;
    if (newNickname != null) {
      nickname = newNickname;
      firebase_auth.FirebaseAuth.instance.currentUser
          .updateProfile(displayName: nickname);
    }
    if (newPhone != null) phone = newPhone;
    if (newAddress != null) {
      //TODO search for address objects
    }
    saveUser();
  }

  // toggle
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

  bool isLoggedIn() {
    return firebase_auth.FirebaseAuth.instance.currentUser != null &&
        !firebase_auth.FirebaseAuth.instance.currentUser.isAnonymous;
  }

  String get documentPath => isLoggedIn()
      ? "users/${firebase_auth.FirebaseAuth.instance.currentUser.uid}"
      : "users/anonymous";

  void signOut() {
    saveUser();
    firebase_auth.FirebaseAuth.instance.signOut();
    nickname = "";
    name = "";
    surname = "";
    phone = "";
    _addressID = null;
    _gardens = <DocumentReference>{};
    _favoredObjects = <String>{};
    notifyListeners();
  }

  @override
  String toString() {
    return "{Nickname: $nickname, Name: $name, Surname: $surname}";
  }
}
