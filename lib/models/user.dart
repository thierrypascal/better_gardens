import 'dart:core';
import 'dart:developer' as logging;

import 'package:biodiversity/components/privacy_agreement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class User with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Set<DocumentReference> _gardens;
  Set<String> _favoredObjects;
  DocumentReference _addressID;
  String nickname;
  String name;
  String surname;
  String phone;
  bool _loggedIn;

  User.empty()
      : _loggedIn = false,
        _gardens = <DocumentReference>{},
        _favoredObjects = <String>{},
        _addressID = null,
        nickname = "",
        name = "",
        surname = "",
        phone = "";

  Future<bool> loadDetailsFromLoggedInUser() async {
    if (!_loggedIn) {
      return false;
    }
    final doc = await FirebaseFirestore.instance.doc(documentPath).get();
    if (!doc.exists) {
      logging.log("Loading failed, no doc found");
      return false;
    }
    logging.log("load details");
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
    logging.log("loaded User: ${toString()}");
    notifyListeners();
    return true;
  }

  Future<bool> saveUser() async {
    if (!_loggedIn) {
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
      String newAddress,
      bool notify = true}) {
    if (newName != null) name = newName;
    if (newSurname != null) surname = newSurname;
    if (newNickname != null) {
      nickname = newNickname;
      FirebaseAuth.instance.currentUser.updateProfile(displayName: nickname);
    }
    if (newPhone != null) phone = newPhone;
    if (newAddress != null) {
      //TODO search for address objects
    }
    saveUser();
    if (notify) {
      notifyListeners();
    }
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

  bool get hasConfirmedEmail =>
      _auth.currentUser != null && _auth.currentUser.emailVerified;

  bool get isLoggedIn => _loggedIn;

  String get documentPath =>
      _loggedIn && FirebaseAuth.instance.currentUser != null
          ? "users/${FirebaseAuth.instance.currentUser.uid}"
          : "users/anonymous";

  void signOut() {
    if (!_loggedIn) {
      return;
    }
    logging.log("start logout");
    saveUser();
    FirebaseAuth.instance.signOut();
    nickname = "";
    name = "";
    surname = "";
    phone = "";
    _addressID = null;
    _gardens = <DocumentReference>{};
    _favoredObjects = <String>{};
    _loggedIn = false;
    notifyListeners();
    logging.log("logout done");
  }

  @override
  String toString() {
    return "{Nickname: $nickname, Name: $name, Surname: $surname}";
  }

  Future<bool> signInWithGoogle({bool register = false}) async {
    if (isLoggedIn) {
      return false;
    }
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      return false;
    }
    final token = await googleAccount.authentication;
    final OAuthCredential credential =
        GoogleAuthProvider.credential(idToken: token.idToken);
    try {
      final UserCredential authUser =
          await _auth.signInWithCredential(credential);
      if (register) {
        authUser.user.updateProfile(displayName: googleAccount.displayName);
        authUser.user.updateEmail(googleAccount.email);
        updateUserData(newNickname: googleAccount.displayName, notify: false);
      }
      _loggedIn = true;
      await loadDetailsFromLoggedInUser();
      return true;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<bool> registerWithGoogle(BuildContext context) async {
    if (isLoggedIn) {
      return false;
    }
    final GoogleSignInAccount googleAccount = await _googleSignIn.signIn();
    if (googleAccount == null) {
      return false;
    }
    if (!await showPrivacyAgreement(context)) {
      return false;
    }
    final token = await googleAccount.authentication;
    final OAuthCredential credential =
        GoogleAuthProvider.credential(idToken: token.idToken);
    try {
      final UserCredential authUser =
          await _auth.signInWithCredential(credential);
      authUser.user.updateProfile(displayName: googleAccount.displayName);
      authUser.user.updateEmail(googleAccount.email);
      updateUserData(newNickname: googleAccount.displayName, notify: false);
      _loggedIn = true;
      await loadDetailsFromLoggedInUser();
      return true;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<String> signInWithEmail(String email, String password) async {
    if (isLoggedIn) {
      return null;
    }
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      if (!_auth.currentUser.emailVerified) {
        _auth.signOut();
        return "Die Email adresse ist noch nicht bestätigt";
      }
      _loggedIn = true;
      await loadDetailsFromLoggedInUser();
      return null;
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> registerWithEmail(String email, String password,
      {String nickname, String name, String surname}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      cred.user.updateProfile(displayName: nickname);
      _loggedIn = true;
      updateUserData(newName: name, newSurname: surname, newNickname: nickname);
      cred.user.sendEmailVerification();
    } on FirebaseAuthException {
      rethrow;
    }
  }
}
