import 'package:biodiversity/account_page.dart';
import 'package:biodiversity/inventar_page.dart';
import 'package:biodiversity/login_page.dart';
import 'package:biodiversity/maps_page.dart';
import 'package:biodiversity/my_garden_page.dart';
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
                MaterialPageRoute(builder: (context) => InventarPage()),
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
