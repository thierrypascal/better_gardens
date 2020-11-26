import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final Future<FirebaseApp> _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text("Something went wrong"),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MultiProvider(
            providers: [
              FutureProvider<User>(
                create: (context) {
                  return User.loadUser('users/testuser');
                },
              ),
              ChangeNotifierProvider<MapInteractionContainer>(
                  create: (context) => MapInteractionContainer.empty())
            ],
            child: MaterialApp(
              title: 'Better Gardens',
              theme: ThemeData(
                // This is the theme of your application.
                primarySwatch: Colors.green,
                disabledColor: const Color.fromRGBO(255, 255, 255, 0.3),

                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: LoginPage(),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
