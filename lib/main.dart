import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


//TODO: Use separate files for each class for better visability


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Better Gardens',
      theme: ThemeData(
        // This is the theme of your application.
        primarySwatch: Colors.green,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title = 'Login';

  @override
  _LoginPageState createState() => _LoginPageState();
}


class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      drawer: MyDrawer(),
      body: Center(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Container(
                      child: Image.asset(
                        'res/logo.png',
                        width: 180,
                      ),
                    ),
                    TextField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'john.doe@mail.com',
                      ),
                    ),
                    TextField(
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: 'Password', hintText: 'Enter password'),
                    ),
                    RaisedButton(child: Text('Login'), onPressed: null),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Sign-Up'), Text('Forgot Password?')],
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}


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
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      drawer: MyDrawer(),
      body: Container(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountEmail: Text('markus.hofer@gmail.com'),
              accountName: Text('Markus Hofer'),
            ),
          ],
        ),
      ),
    );
  }
}

class MapsPage extends StatefulWidget {
  MapsPage({Key key}) : super(key: key);

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;

  final LatLng _center = const LatLng(46.948915, 7.445423);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Karte'),
      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: _center,
          zoom: 14.0,
        ),
      ),
    );
  }
}


class ListPage extends StatefulWidget {
  ListPage({Key key}) : super(key: key);


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste'),
      ),
      drawer: MyDrawer(),
      body: new DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            bottom: TabBar(
              tabs: [
                Tab(text: 'ELEMENT',),
                Tab(text: 'PFLANZE',),
                Tab(text: 'METHODE',),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              ElementListe(),
              PflanzenListe(),
              MethodenListe(),
            ],
          ),
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class ElementListe extends StatelessWidget {
  ElementListe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            // Use a delegate to build items as they're scrolled on screen.
            delegate: SliverChildBuilderDelegate(
              // The builder function returns a ListTile with a title that
              // displays the index of the current item.
                  (context, index) => ListTile(title: Text('Element #$index')),
              // Builds 200 ListTiles
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class PflanzenListe extends StatelessWidget {
  PflanzenListe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Pflanze #$index')),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each listelement into expandable
class MethodenListe extends StatelessWidget {
  MethodenListe({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) => ListTile(title: Text('Methode #$index')),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }
}




class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(''),
          ),
          ListTile(
            title: Text('Login'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
          ListTile(
            title: Text('Map'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MapsPage()),
              );
            },
          ),
          ListTile(
            title: Text('Account'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AccountPage()),
              );
            },
          ),
          ListTile(
            title: Text('My Garden'),
            onTap: () {
              // Update the state of the app.
              // ...
            },
          ),
          ListTile(
            title: Text('List'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPage()),
              );
            },
          ),
          ListTile(
            title: Text('Bookmarks'),
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
