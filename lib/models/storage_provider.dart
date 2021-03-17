import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

/// A class which provides a single place where external Storage is accessed
class StorageProvider {
  final FirebaseStorage fileStorage = FirebaseStorage();
  final FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FacebookAuth facebookAuth = FacebookAuth.instance;
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
}
