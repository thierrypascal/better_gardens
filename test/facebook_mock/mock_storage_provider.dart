import 'package:biodiversity/models/storage_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_storage_mocks/firebase_storage_mocks.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:mockito/mockito.dart';

import 'mock_facebook_auth.dart';

class MockStorageProvider extends Mock implements StorageProvider {
  final FirebaseStorage fileStorage = MockFirebaseStorage();
  final FirebaseFirestore database = MockFirestoreInstance();
  final FirebaseAuth auth = MockFirebaseAuth();
  final GoogleSignIn googleSignIn = MockGoogleSignIn();
  final FacebookAuth facebookAuth = MockFacebookAuth();
  final GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
}
