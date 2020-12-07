import 'package:biodiversity/screens/account_page/account_page.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_measures_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_page.dart';
import 'package:biodiversity/screens/species_list_page/species_list_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppBar appbar;
    return Drawer(
      child: Theme(
        data: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Colors.green[700],
            scaffoldBackgroundColor: Theme
                .of(context)
                .colorScheme
                .primary,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  color:
                  Theme
                      .of(context)
                      .colorScheme
                      .onPrimary
                      .withOpacity(0.8),
                  fontSize: 16),
            )),
        child: Scaffold(
          appBar: appbar = AppBar(),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: constraints.copyWith(
                      minHeight: constraints.maxHeight,
                      maxHeight: double.infinity,
                    ),
                    child: IntrinsicHeight(
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            title: const Text('Karte'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MapsPage()),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Account'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AccountPage()),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Mein Garten'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyGarden()),
                              );
                              // ...
                            },
                          ),
                          ListTile(
                            title: const Text('Nachrichten'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Biodiversität Massnahmen'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => InformationListPage()),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Spezien'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SpeciesListPage()),
                              );
                            },
                          ),
                          ListTile(
                            title: const Text('Merkliste'),
                            onTap: () {},
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.arrow_forward,
                              color: Colors.white.withOpacity(0.8),
                            ),
                            title: const Text('Stadtwildtiere'),
                            onTap: () {},
                          ),
                          ListTile(
                            title: const Text('Login'),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginPage()),
                              );
                            },
                          ),
                          const Expanded(
                            child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Image(
                                  image: AssetImage('res/gardenDrawer.png'),
                                ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
          ),
        ),
      ),
    );
  }
}
