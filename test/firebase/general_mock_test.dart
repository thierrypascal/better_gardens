// import 'package:flutter/material.dart';
//import '../../lib/authentication/your_auth_using_firebase.dart';
import 'package:biodiversity/main.dart';
import 'package:biodiversity/models/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_test/flutter_test.dart';

import './firebase_auth_mock.dart'; // from: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_auth/firebase_auth/test/mock.dart
// see more here: https://stackoverflow.com/questions/63662031/how-to-mock-the-firebaseapp-in-flutter

void main() {
  // TestWidgetsFlutterBinding.ensureInitialized(); Gets called in setupFirebaseAuthMocks()
  setupFirebaseAuthMocks();

  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('Your Test', (WidgetTester tester) async {
    final MyApp authService = MyApp();
    User testUser = User.empty();
    testUser.updateUserData(newName: "Manu");
    expect(testUser.name, "Manu");
    expect(testUser.isLoggedIn(), false);
    expect(testUser.doesLikeElement("plant"), false);
    testUser.likeUnlikeElement("plant");
    expect(testUser.doesLikeElement("plant"), true);
    // Tests to write
  });
}
