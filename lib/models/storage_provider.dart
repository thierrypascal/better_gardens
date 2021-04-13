import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A class which provides a single place where external Storage is accessed
class StorageProvider {
  /// Reference to the file-storage instance
  final FirebaseStorage fileStorage = FirebaseStorage.instance;

  /// Reference to the database instance
  final FirebaseFirestore database = FirebaseFirestore.instance;

  /// Reference to the authentication service instance
  final FirebaseAuth auth = FirebaseAuth.instance;

  /// Reference to the google sign in provider
  final GoogleSignIn googleSignIn = GoogleSignIn();

  /// Reference to the facebook oAuth provider
  final FacebookAuth facebookAuth = FacebookAuth.instance;

  /// Reference to the google oAuth provider
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();

  /// returns the content of a file from the fileStorage as String
  Future<String> getTextFromFileStorage(String path) async {
    final data = await fileStorage.ref().child(path).getData(1024 * 1024);
    return const Utf8Decoder().convert(data);
  }
}
