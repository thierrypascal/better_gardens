import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';

import 'mock_firestore_base.dart';

class MockStorageProvider extends Mock implements StorageProvider {
  @override
  final FirebaseStorage fileStorage = MockFirebaseStorage();
  @override
  final FirebaseFirestore database = MockFirestoreInstance();
  @override
  final FirebaseAuth auth = MockFirebaseAuth();
  @override
  final GoogleSignIn googleSignIn = MockGoogleSignIn();
  @override
  final FacebookAuth facebookAuth = null;
  @override
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
}
