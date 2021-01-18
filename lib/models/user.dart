import 'dart:core';
import 'dart:developer' as logging;

import 'package:biodiversity/components/privacy_agreement.dart';
import 'package:biodiversity/models/login_result.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// The User class holds all information about the User of the app
/// The class is built to be used as a singleton,
/// so only one instance should be used throughout the app.
class User extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Set<DocumentReference> _gardens;
  Set<String> _favoredObjects;
  DocumentReference _addressID;
  bool _loggedIn;

  /// The nickname is a name which is used to represent the user anonymously
  String nickname;

  /// The name is the name of the user like Gabriel
  String name;

  /// The surname is the family name of the user like Ineichen
  String surname;

  /// the phone String is a mobile phone number
  String phone;

  /// Provides an empty User object. This should only be used once at App start.
  User.empty()
      : _loggedIn = false,
        _gardens = <DocumentReference>{},
        _favoredObjects = <String>{},
        _addressID = null,
        nickname = "",
        name = "",
        surname = "",
        phone = "";

  /// Loads the details like nickname, liked objects etc. form the database
  /// After the details are loaded, the listeners are notified
  /// Reruns false if the User is not logged in
  /// or the document referenced by [documentPath] was not found.<br>
  /// If the flag informListeners is set, the listeners will be notified.
  Future<bool> loadDetailsFromLoggedInUser(
      {bool informListeners = true}) async {
    if (!_loggedIn) {
      return false;
    }
    final doc = await FirebaseFirestore.instance.doc(documentPath).get();
    if (!doc.exists) {
      logging.log("Loading failed, no doc found");
      return false;
    }
    logging.log("load details");
    final map = doc.data();
    if (map.containsKey('nickname') && map['nickname'] is String) {
      nickname = map['nickname'];
    }
    if (map.containsKey('name') && map['name'] is String) {
      name = map['name'];
    }
    if (map.containsKey('surname') && map['surname'] is String) {
      surname = map['surname'];
    }
    if (map.containsKey('addressID') && map['addressID'] is DocumentReference) {
      _addressID = map['addressID'];
    }
    if (map.containsKey('phone') && map['phone'] is String) {
      phone = map['phone'];
    }
    if (map.containsKey('gardens') && map['gardens'] is List) {
      _gardens = Set<DocumentReference>.from(map['gardens']);
    }
    if (map.containsKey('favoredObjects') && map['favoredObjects'] is List) {
      _favoredObjects = Set.from(map['favoredObjects']);
    }
    logging.log("loaded User: ${toString()}");
    if (informListeners) {
      notifyListeners();
    }
    return true;
  }

  ///saves all information from the [User] Class to the database
  ///returns [false] if no user is logged in
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

  ///changes any field of the [User].
  ///Afterwards the changes are saved to the database
  ///and the listeners will be informed if the flag [informListeners] is set.
  void updateUserData(
      {String newName,
      String newSurname,
      String newNickname,
      String newPhone,
      String newAddress,
      bool informListeners = true}) {
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
    if (informListeners) {
      notifyListeners();
    }
  }

  /// toggle for a given element.
  /// No checks are made if the element is actually featured in the database
  void likeUnlikeElement(String element) {
    if (_favoredObjects.contains(element)) {
      _favoredObjects.remove(element);
    } else {
      _favoredObjects.add(element);
    }
    notifyListeners();
    saveUser();
  }

  /// returns a [bool] whether the User has liked the given element
  bool doesLikeElement(String element) {
    return _favoredObjects.contains(element);
  }

  /// is true if the User has confirmed his email address by the sent link
  bool get hasConfirmedEmail =>
      _auth.currentUser != null && _auth.currentUser.emailVerified;

  /// is true if the user is logged in
  bool get isLoggedIn => _loggedIn;

  /// returns a [String] with the path to the users profile in the database
  String get documentPath =>
      _loggedIn && FirebaseAuth.instance.currentUser != null
          ? "users/${FirebaseAuth.instance.currentUser.uid}"
          : "users/anonymous";

  /// signs the user out, saves all data to the database.
  /// The listeners will be notified
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

  /// Signs the user in with a google account.<br>
  /// The selection which User should be used will apear as a pop up
  /// In case of success returns [null], otherwise a [LoginResult] object
  /// with the message set and additionally the flag isPrivacyAgreementAccepted
  /// set to false if the user isn't registered
  Future<LoginResult> signInWithGoogle({bool register = false}) async {
    if (!isLoggedIn) {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        return LoginResult("Anmeldung abgebrochen.");
      }
      final token = await googleAccount.authentication;
      final credential = GoogleAuthProvider.credential(idToken: token.idToken);
      try {
        final signInMethods =
            await _auth.fetchSignInMethodsForEmail(googleAccount.email);
        if (!signInMethods.contains("google")) {
          return LoginResult("Bitte registrieren Sie sich zuerst.",
              isPrivacyAgreementAccepted: false);
        }
        await _auth.signInWithCredential(credential);
        _loggedIn = true;
        await loadDetailsFromLoggedInUser();
        return null;
      } on FirebaseAuthException catch (error) {
        if (error.code == "invalid-email") {
          // This should not be possible,
          // since the email is fetched from the google account
          return LoginResult("Deine Email adresse ist ungültig");
        }
      }
    }
  }

  ///Signs the user in with the provided Email and password
  ///if an error occurs returns a [LoginResult] object
  ///with a message as string and a flag [isEmailConfirmed which indicates
  ///if the user has already confirmed his email address
  ///<br> if no error occurs [null] is returned.
  Future<LoginResult> signInWithEmail(String email, String password) async {
    if (!isLoggedIn) {
      try {
        await _auth.signInWithEmailAndPassword(
            email: email, password: password);
        if (!_auth.currentUser.emailVerified) {
          _auth.signOut();
          return LoginResult("Bitte bestätigen Sie zuerst ihre Email Adresse",
              isEmailConfirmed: false);
        }
        _loggedIn = true;
        await loadDetailsFromLoggedInUser();
      } on FirebaseAuthException catch (error) {
        if (error.code == "invalid-email") {
          return LoginResult("Die eingegebene Email Adresse ist ungültig.");
        } else if (error.code == "user-disabled") {
          return LoginResult("Ihr Konto wurde gesperrt. "
              "Bite wenden Sie sich an den Support.");
        } else {
          return LoginResult("Die Email Adresse oder das Passwort ist falsch");
        }
      }
    }
    return null;
  }

  ///Displays the google account selection popup and the privacy agreement.<br>
  ///Afterwards the user is signed in automatically
  Future<bool> registerWithGoogle(BuildContext context) async {
    if (!isLoggedIn) {
      final googleAccount = await _googleSignIn.signIn();
      if (googleAccount == null) {
        return false;
      }
      final token = await googleAccount.authentication;
      if (!await showPrivacyAgreement(context)) {
        return false;
      }
      final credential = GoogleAuthProvider.credential(idToken: token.idToken);
      try {
        final authUser = await _auth.signInWithCredential(credential);
        authUser.user.updateProfile(displayName: googleAccount.displayName);
        authUser.user.updateEmail(googleAccount.email);
        updateUserData(
            newNickname: googleAccount.displayName, informListeners: false);
        _loggedIn = true;
        await loadDetailsFromLoggedInUser();
      } on FirebaseAuthException {
        rethrow;
      }
    }
    return _loggedIn;
  }

  /// Registers a user with the provided email address and password.
  /// An email will be sent to confirm the users email address.<br>
  /// The User is not logged in afterwards.
  /// Sign in is only possible after the user has confirmed his email address.
  /// <br>returns an error Message which can be displayed if something
  /// goes wrong. Or [null] if everything is fine.
  Future<String> registerWithEmail(String email, String password,
      {String nickname, String name, String surname}) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      cred.user.updateProfile(displayName: nickname);
      updateUserData(newName: name, newSurname: surname, newNickname: nickname);
      cred.user.sendEmailVerification();
    } on FirebaseAuthException catch (error) {
      if (error.code == "invalid-email") {
        return "Die eingegebene Email Adresse ist ungültig.";
      } else if (error.code == "email-already-in-use") {
        return "Die angegebene Email Adresse wird bereits verwendet.";
      } else if (error.code == "weak-password") {
        return "Das angegebene Passwort ist zu schwach. "
            "Ihr Passwort sollte mindestens 6 Zeichen lang sein "
            "und Zahlen sowie Gross- und Kleinbuchstaben beinhalten.";
      } else {
        return "Something went wrong.";
      }
    }
    return null;
  }

  /// sends the mail to confirm the email address again
  Future<String> sendEmailConfirmation(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      await _auth.currentUser.sendEmailVerification();
      _auth.signOut();
    } on FirebaseAuthException catch (error) {
      return "Something went wrong";
    }
    return null;
  }

  /// Sends a password reset link to the provided email.
  Future<bool> sendPasswordResetLink(String email) async {
    final methods = await _auth.fetchSignInMethodsForEmail(email);
    if (methods.contains("password")) {
      _auth.sendPasswordResetEmail(email: email);
      return true;
    }
    return false;
  }

  /// returns a list of possible sign in methods for the provided email
  Future<List<String>> getSignInMethods(String email) async {
    try {
      return _auth.fetchSignInMethodsForEmail(email);
    } on FirebaseAuthException catch (error) {
      return [];
    }
  }
}
