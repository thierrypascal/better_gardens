import 'package:flutter/material.dart';
import 'package:biodiversity/drawer.dart';

class AccountPage extends StatefulWidget {
  AccountPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Account'),
          //TODO Make header display properly
          /* flexibleSpace: UserAccountsDrawerHeader(
            accountEmail: Text('markus.hofer@gmail.com'),
            accountName: Text('Markus Hofer'),
            currentAccountPicture: CircleAvatar(
              child: FlutterLogo(size: 42.0),
            ),
          ), */
        ),
        drawer: MyDrawer(),
        body: TabBarView(
          children: [
            //TODO Create the actual tab contents
            Icon(Icons.info),
            Icon(Icons.grass),
            Column(),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
            items: [
            BottomNavigationBarItem(label: 'My Info', icon: Icon(Icons.person)),
            BottomNavigationBarItem(label: 'My Garden',icon: Icon(Icons.nature_people)),
            BottomNavigationBarItem(label: 'My Posts',icon: Icon(Icons.local_post_office)),
            ],
        ),
      ),
    );
  }
}