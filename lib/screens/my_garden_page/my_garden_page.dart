import 'dart:ui';

import 'package:biodiversity/components/drawer.dart';
import 'package:biodiversity/components/information_object_list_widget.dart';
import 'package:biodiversity/models/garden.dart';
import 'package:biodiversity/screens/my_garden_page/my_garden_edit.dart';
import 'package:biodiversity/services/service_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: const Text('Mein Garten'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'MyGardenEdit',
                child: Row(
                  children: [
                    const Padding(
                      child: Icon(
                        Icons.perm_contact_calendar_sharp,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.only(right: 10),
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
                      child: Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.only(right: 10),
                    ),
                    const Text('Garten hinzfügen')
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'myGardenPage',
                child: Row(
                  children: [
                    const Padding(
                      child: Icon(
                        Icons.home,
                        color: Colors.black,
                      ),
                      padding: EdgeInsets.only(right: 10),
                    ),
                    const Text('Zu Garten_1 wechseln')
                  ],
                ),
              ),
            ],

            onSelected: _handleTopMenu,
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('gardens').snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const CircularProgressIndicator();
          }

          return _buildBody(context, snapshot.data.docs);
        },
      ),
      floatingActionButton: _floatingActionButton(),
    );

  }
  _handleTopMenu(String value) {
  switch (value) {
    case 'MyGardenEdit':
      {
        Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyGardenEdit()),
              );

      }
      break;
    case 'gardenAddPage':
      {
        //TODO sina add page

        break;
      }
  }
}
}

Widget _floatingActionButton() {
  return FloatingActionButton(
    onPressed: () {},
    child: const Icon(
      Icons.add,
      size: 30.0,
      color: Colors.white,
    ),
  );
}

Widget _buildBody(BuildContext context, List<DocumentSnapshot> snapshot) {
  final garden = Provider.of<Garden>(context);
  final _textController = TextEditingController(text: garden.name);

  void _onSaveGarden() {
    if (garden.name != _textController.text.trim()) {
      garden.name = _textController.text.trim();
      garden.saveGarden();
    }
  }

  return PageView(
    scrollDirection: Axis.vertical,
    children: <Widget>[
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
                const Text(
                  'Zusammenfassung von Schrebergarten_1:\n',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
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
                            style: TextStyle(fontSize: 16, color: Colors.black))
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
                  .getAllBiodiversityMeasuresFromUsersActiveGarden(),
            ),
          ),
        ],
      ),
    ],
  );
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


