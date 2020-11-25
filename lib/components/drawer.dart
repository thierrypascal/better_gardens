import 'package:biodiversity/screens/account_page/account_page.dart';
import 'package:biodiversity/screens/information_list_page/information_list_page.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/screens/map_page/maps_page.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_page.dart';
import 'package:flutter/material.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            child: Text(''),
          ),
          ListTile(
            title: const Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Map'),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MapsPage(46.948915, 7.445423),)
              );
            },
          ),
          ListTile(
            title: const Text('Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
          ListTile(
            title: const Text('My Garden'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyGarden()),
              );
              // ...
            },
          ),
          ListTile(
            title: const Text('Inventar'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InformationListPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Bookmarks'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
        ],
      ),
    );
  }
}
