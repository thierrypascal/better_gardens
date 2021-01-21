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

  testWidgets('User test', (tester) async {
    final authService = MyApp();
    final testUser = User.empty();
    testUser.updateUserData(newName: "Manu");
    expect(testUser.name, "Manu", reason: "Set name was wrong");
    expect(testUser.isLoggedIn, false, reason: "User not logged in");
    expect(testUser.doesLikeElement("plant"), false,
        reason: "Should not like element before it is liked");
    testUser.likeUnlikeElement("plant");
    expect(testUser.doesLikeElement("plant"), true,
        reason: "Should like element after like action");
    expect(await testUser.loadDetailsFromLoggedInUser(), false,
        reason: "Should return false since the user is not logged in");
    // Tests to write
  });
}
