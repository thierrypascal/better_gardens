import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/email_login_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import '../facebook_mock/mock_storage_provider.dart';

final _globalKey = GlobalKey();

Widget loadProviders(Widget widget,
    {String name = 'Gabriel',
    String password = '123456',
    String email = 'gabriel@tester.com'}) {
  final storage = MockStorageProvider();
  return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => User.empty(storage),
          lazy: false,
        ),
        ChangeNotifierProvider(
            create: (context) => BiodiversityService(storage)),
        ChangeNotifierProvider(create: (context) => SpeciesService(storage)),
        ChangeNotifierProvider(
            create: (context) => MapInteractionContainer.empty()),
        ChangeNotifierProvider(
          create: (context) => MapMarkerService(context, storage),
        ),
      ],
      child: MaterialApp(
        key: _globalKey,
        home: widget,
      ));
}

void main() {
  testWidgets('Check if all login options are present', (tester) async {
    await tester.pumpWidget(loadProviders(LoginPage()));

    final emailLogin = find.text('E-mail');
    final googleLogin = find.text('Google');
    final facebookLogin = find.text('Facebook');

    expect(emailLogin, findsOneWidget, reason: 'E-mail login option not found');
    expect(googleLogin, findsOneWidget,
        reason: 'Google login option not found');
    expect(facebookLogin, findsOneWidget,
        reason: 'Facebook login option not found');
  });

  testWidgets('Test Email login', (tester) async {
    await tester.pumpWidget(loadProviders(LoginPage()));
    await tester.tap(find.text('E-mail'));
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsNothing,
        reason: 'LoginPage still loaded, should be EmailLoginPage');
    expect(find.byType(EmailLoginPage), findsOneWidget,
        reason: 'EmailLoginPage not loaded');
  });
}
