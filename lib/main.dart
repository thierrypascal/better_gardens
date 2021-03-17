import 'package:biodiversity/models/biodiversity_service.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/map_marker_service.dart';
import 'package:biodiversity/models/species_service.dart';
import 'package:biodiversity/models/storage_provider.dart';
import 'package:biodiversity/models/take_home_message_service.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

/// The mainActivity of the flutter app
// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final _initialization = Firebase.initializeApp();

    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.connectionState == ConnectionState.done) {
          final storage = StorageProvider();
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => User.empty(storage),
                lazy: false,
              ),
              ChangeNotifierProvider(
                create: (context) => BiodiversityService(storage),
                lazy: false,
              ),
              ChangeNotifierProvider(
                create: (context) => SpeciesService(storage),
                lazy: false,
              ),
              ChangeNotifierProvider(
                create: (context) => TakeHomeMessageService(storage),
                lazy: false,
              ),
              ChangeNotifierProvider(
                  create: (context) => MapInteractionContainer.empty()),
              ChangeNotifierProvider(
                create: (context) => MapMarkerService(context, storage),
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
                bottomSheetTheme: const BottomSheetThemeData(
                    backgroundColor: Colors.green,
                    modalBackgroundColor: Colors.green),
                errorColor: Colors.redAccent,

                // This makes the visual density adapt to the platform that you
                // run the app on. For desktop platforms, the controls will be
                // smaller and closer together
                // (more dense)
                // than on mobile platforms.
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
