import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
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
              ChangeNotifierProvider<BiodiversityService>(
                  create: (context) => BiodiversityService()),
              ChangeNotifierProvider<MapInteractionContainer>(
                  create: (context) => MapInteractionContainer.empty()),
              ChangeNotifierProvider<MapMarkerService>(
                create: (context) => MapMarkerService(context),
              ),
            ],
            child: MaterialApp(
              title: 'Better Gardens',
              theme: ThemeData(
                // This is the theme of your application.
                primarySwatch: Colors.green,
                disabledColor:
                    Theme.of(context).colorScheme.onPrimary.withOpacity(0.5),
                dividerColor: Colors.grey,

                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              //home: LoginPage(),
              home: MapsPage(),
            ),
          );
        }

        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
