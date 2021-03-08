import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/email_login_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:cloud_firestore_mocks/cloud_firestore_mocks.dart';
import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_sign_in_mocks/google_sign_in_mocks.dart';
import 'package:provider/provider.dart';

import '../facebook_mock/facebook_auth_mock.dart';

final _globalKey = GlobalKey();

Widget loadProviders(Widget widget,
    {String name = "Gabriel",
    String password = "123456",
    String email = "gabriel@tester.com"}) {
  final firebase = MockFirestoreInstance();
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User.empty(
            MockFirebaseAuth(),
            firebase,
            MockGoogleSignIn(),
            FacebookAuthMock(mockUser: FacebookMockUser(name, password, email)),
          ),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (context) => BiodiversityService(firebase)),
        ChangeNotifierProvider(create: (context) => SpeciesService()),
        ChangeNotifierProvider(
            create: (context) => MapInteractionContainer.empty()),
        ChangeNotifierProvider(
          create: (context) => MapMarkerService(context),
        ),
      ],
      child: MaterialApp(
        key: _globalKey,
        home: widget,
      ));
}

void main() {
  testWidgets("Check if all login options are present", (tester) async {
    await tester.pumpWidget(loadProviders(LoginPage()));

    final emailLogin = find.text("E-mail");
    final googleLogin = find.text("Google");
    final facebookLogin = find.text("Facebook");

    expect(emailLogin, findsOneWidget, reason: "E-mail login option not found");
    expect(googleLogin, findsOneWidget,
        reason: "Google login option not found");
    expect(facebookLogin, findsOneWidget,
        reason: "Facebook login option not found");
  });

  testWidgets("Test Email login", (tester) async {
    await tester.pumpWidget(loadProviders(LoginPage()));
    await tester.tap(find.text("E-mail"));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing,
        reason: "LoginPage still loaded, should be EmailLoginPage");
    expect(find.byType(EmailLoginPage), findsOneWidget,
        reason: "EmailLoginPage not loaded");
  });
}
