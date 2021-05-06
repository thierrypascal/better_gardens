import 'dart:ui';

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/information_object_list_widget.dart';
import 'package:biodiversity/components/white_redirect_page.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/models/user.dart';
import 'package:biodiversity/screens/login_page/login_page.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_add.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_edit.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Displays the page where the user can see his own garden
class MyGarden extends StatefulWidget {
  /// Displays the page where the user can see his own garden
  MyGarden({Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MyGardenState();
  }
}

class _MyGardenState extends State<MyGarden> {
  List<Garden> gardens;
  Garden garden;

  @override
  Widget build(BuildContext context) {
    gardens = ServiceProvider.instance.gardenService
        .getAllGardensFromUser(Provider.of<User>(context));
    garden = Provider.of<Garden>(context);
    if (gardens.isNotEmpty && garden.isEmpty) {
      garden = gardens.first;
    }

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Mein Garten'),
        actions: [
          PopupMenuButton(
            onSelected: _handleTopMenu,
            itemBuilder: (context) {
              final _menuItems = [
                PopupMenuItem(
                  value: 'MyGardenEdit',
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.perm_contact_calendar_sharp,
                          color: Colors.black,
                        ),
                      ),
                      const Text('Garten bearbeiten'),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'gardenAddPage',
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.add,
                          color: Colors.black,
                        ),
                      ),
                      const Text('Garten hinzfügen')
                    ],
                  ),
                ),
              ];
              final _gardens = gardens.map((garden) => garden.name);
              if (_gardens.length <= 1) {
                return _menuItems;
              }
              for (final _garden in _gardens) {
                _menuItems.add(PopupMenuItem(
                  value: _garden,
                  child: Row(
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Icon(
                          Icons.home,
                          color: Colors.black,
                        ),
                      ),
                      Text('Zu $_garden wechseln'),
                    ],
                  ),
                ));
              }
              return _menuItems;
            },
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: PageView(
        scrollDirection: Axis.vertical,
        children: <Widget>[
          if (gardens.isEmpty)
            Column(
              children: [
                Image(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  fit: BoxFit.fitWidth,
                  image: const AssetImage('res/myGarden.jpg'),
                  semanticLabel: garden.name,
                ),
                Padding(
                  padding: const EdgeInsets.all(25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                          'Hallo\n\nHier siehst du die Übersicht über deinen Garten.\n'
                          'Damit du Lebensräume in deinem Garten hinzufügen kannst '
                          'und dich mit anderen Gärtnern vernetzen kannst musst du zuerst einen Garten erstellen.',
                          style: TextStyle(fontSize: 15)),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (Provider.of<User>(context, listen: false)
                              .isLoggedIn) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MyGardenAdd()));
                          } else {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => WhiteRedirectPage(
                                        'Bitte melde dich zuerst noch an.',
                                        LoginPage())));
                          }
                        },
                        child: const Text('Einen Garten erstellen'),
                      ),
                    ],
                  ),
                ),
              ],
            )
          else
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: AlignmentDirectional.center,
                  children: <Widget>[
                    Image(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      fit: BoxFit.fitWidth,
                      image: const AssetImage('res/myGarden.jpg'),
                      semanticLabel: garden.name,
                    ),
                    Center(
                      child: Text(
                        garden.name,
                        textAlign: TextAlign.center,
                        softWrap: true,
                        textScaleFactor: 2,
                        style: const TextStyle(
                            color: Color.fromRGBO(255, 255, 255, 0.8)),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 30, left: 30, top: 50),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Zusammenfassung von ${garden.name}:\n',
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      _differentCircles(context),
                      const SizedBox(height: 15.0),
                      TextButton(
                          //TODO functionality to see the garden in the map
                          onPressed: () {},
                          child: Row(
                            children: <Widget>[
                              const Icon(Icons.maps_ugc_outlined),
                              const SizedBox(width: 10.0),
                              const Text('Garten auf Karte anzeigen',
                                  style: TextStyle(
                                      fontSize: 16, color: Colors.black))
                            ],
                          )),
                    ],
                  ),
                ),
              ],
            ),
          Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                child: Text('Lebensräume in Ihrem Garten suchen',
                    style: TextStyle(fontSize: 20, color: Colors.black)),
              ),
              Expanded(
                child: InformationObjectListWidget(
                  objects: ServiceProvider.instance.gardenService
                      .getAllBiodiversityMeasuresFromGarden(garden),
                  showDeleteAndEdit: true,
                  hideLikeAndAdd: true,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _handleTopMenu(String value) {
    if (value == 'MyGardenEdit') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyGardenEdit()));
    } else if (value == 'gardenAddPage') {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => MyGardenAdd()));
    } else {
      final _garden = gardens.where((garden) => garden.name == value).first;
      Provider.of<Garden>(context, listen: false).switchGarden(_garden);
    }
  }

  Widget _createCircle(String number, String text) {
    return Container(
      height: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              border: Border.all(width: 2),
              shape: BoxShape.circle,
              // You can use like this way or like the below line
              //borderRadius: new BorderRadius.circular(30.0),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(number, style: const TextStyle(fontSize: 20.0)),
              ],
            ),
          ),
          Text(text, style: const TextStyle(color: Colors.grey))
        ],
      ),
    );
  }

  Widget _differentCircles(BuildContext context) {
    final garden = Provider.of<Garden>(context);
    return Column(children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createCircle('${garden.totalAreaObjects}', 'Flächen (m2)'),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _createCircle('${garden.totalLengthObjects}', ' Längen (m)')
          ]),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _createCircle(
                  '${garden.totalPointObjects}', 'Punktobjekt (Anzahl)'),
            ],
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
            _createCircle(
                '${garden.totalSupportedSpecies}', 'Geförderte Arten (Anzahl)')
          ]),
        ],
      )
    ]);
  }
}
