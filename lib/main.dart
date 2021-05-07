import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/information_object_amount_container.dart';
import 'package:biodiversity/models/map_interactions_container.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

/// The mainActivity of the flutter app
// ignore: use_key_in_widget_constructors
class MyApp extends StatelessWidget {
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
          // load services and the related content
          ServiceProvider.instance;
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(
                create: (context) => User.empty(),
                lazy: false,
              ),
              ChangeNotifierProxyProvider<User, Garden>(
                  create: (context) => Garden.empty(),
                  update: (context, user, garden) => Garden.fromUser(user)),
              ChangeNotifierProvider(
                  create: (context) => MapInteractionContainer.empty()),
              ChangeNotifierProvider(
                  create: (context) => InformationObjectAmountContainer())
            ],
            child: MaterialApp(
              title: 'Better Gardens',
              theme: ThemeData(
                buttonBarTheme: const ButtonBarThemeData(
                    alignment: MainAxisAlignment.spaceBetween),
                // This is the theme of your application.
                //brightness: Brightness.dark, // set this for darkmode
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
