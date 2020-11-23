import 'dart:developer' as logging;
import 'package:biodiversity/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapsPage extends StatefulWidget {
  MapsPage(
    this.latitude,
    this.longitude, {
    Key key,
  }) : super(key: key);
  final double latitude;
  final double longitude;

  @override
  _MapsPageState createState() => _MapsPageState();
}

class _MapsPageState extends State<MapsPage> {
  GoogleMapController mapController;
  List<Marker> myMarker = <Marker>[];
  LatLng tapPosition;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    //auslagern auf database
    myMarker.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(46.946667, 7.451944),
        infoWindow: const InfoWindow(
          title: 'Münsterplattform',
          snippet: 'Das Münster ist wundervoll',
        )));
  }

  _setPosition(LatLng tapPos) {
    tapPosition = tapPos;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
      ),
      drawer: MyDrawer(),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        compassEnabled: true,
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        markers: Set.from(myMarker),
        onTap: _setPosition,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapIcon()),
          );
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

class AddMapIcon extends StatelessWidget{
  String dropdownValue = 'One';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => showList()),
              );
            },
            child: Text('wähle ein Element'),
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Abbrechen'),
              ),
              ElevatedButton(
                onPressed: () {
                  //save to database
                  Navigator.pop(context);
                },
                child: Text('Speichern'),
              ),
            ],
          ),
        ]
      ),
    );
  }
}

class showList extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
      ),
      body: Column(
          children: <Widget>[
            Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Abbrechen'),
                ),
              ],
            ),
          ]
      ),
    );
  }
}



/*  Widget AddMapIcon(){
    setState(() {
      DefaultTabController(
        length: 3,
        child: Scaffold(
          drawer: MyDrawer(),
          appBar: AppBar(
            title: const Text('List'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  text: 'ELEMENT',
                ),
                Tab(
                  text: 'PLANT',
                ),
                Tab(
                  text: 'METHOD',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: <Widget>[
              subList('Element'),
              subList('Plant'),
              subList('Method')
            ],
          ),
        ),
      );
    });
  }

  Widget subList(String elementType){
    return Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                  ListTile(
                      leading: IconButton(
                        icon: Icon(Icons.add),
                        onPressed: () {
                          //_createMapIcon();
                        },
                      ),
                      title: Text("$elementType: $index")),
              childCount: 200,
            ),
          ),
        ],
      ),
    );
  }

  void _createMapIcon(LatLng tappedPoint) {
    setState(() {
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()), //if tappedPoint is null, use current location
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            logging.log(dragEndPosition.toString());
          }));
    });
  }*/
