import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/account_page/account_page.dart';
import 'package:biodiversity/screens/information_list_page/biodiversity_measures_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_page.dart';
import 'package:biodiversity/screens/species_list_page/species_list_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Theme(
        data: ThemeData(
            primarySwatch: Colors.green,
            primaryColor: Colors.green[700],
            scaffoldBackgroundColor: Theme.of(context).colorScheme.primary,
            textTheme: TextTheme(
              bodyText1: TextStyle(
                  color:
                      Theme.of(context).colorScheme.onPrimary.withOpacity(0.8),
                  fontSize: 16),
            )),
        child: Scaffold(
          appBar: AppBar(),
          body: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    ListTile(
                      title: const Text('Karte'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => MapsPage()),
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
                          MaterialPageRoute(builder: (context) => MyGarden()),
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
                    // ignore: prefer_if_elements_to_conditional_expressions
                    _loginLogoutButton(),

                    const Image(
                      image: AssetImage('res/gardenDrawer.png'),
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _loginLogoutButton extends StatefulWidget {
  @override
  _loginLogoutButtonState createState() => _loginLogoutButtonState();
}

class _loginLogoutButtonState extends State<_loginLogoutButton> {
  @override
  Widget build(BuildContext context) {
    if (Provider.of<User>(context).isLoggedIn) {
      return ListTile(
        title: const Text('Logout'),
        onTap: () => _signOut(context),
      );
    } else {
      return ListTile(
        title: const Text('Login'),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        ),
      );
    }
  }

  void _signOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("ausloggen ?"),
              content: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text("Ausloggen"),
                  ),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text("Abbrechen"),
                  ),
                ],
              ),
            )).then((value) {
      if (value != null) {
        Provider.of<User>(context, listen: false).signOut();
      }
    });
  }
}
