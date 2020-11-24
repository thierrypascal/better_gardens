import 'dart:async';
import 'dart:developer' as logging;
import 'package:biodiversity/globals.dart' as globals;
import 'package:biodiversity/drawer.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';


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
  List<Marker> markerList = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});

    //auslagern auf database
    globals.markerList.add(Marker(
        markerId: MarkerId('SomeId'),
        position: LatLng(46.946667, 7.451944),
        infoWindow: const InfoWindow(
          title: 'Münsterplattform',
          snippet: 'Das Münster ist wundervoll',
        )));
  }

  void _setPosition(LatLng tapPos) {
    globals.tappedPoint = tapPos;
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
        markers: Set.from(globals.markerList),
        onTap: _setPosition,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddMapIcon()),    //opens selection page
          ).then(onGoBack);
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }

  FutureOr onGoBack(dynamic value){
    globals.markerList = globals.markerList;
    setState((){});
  }
}

class AddMapIcon extends StatefulWidget {
  AddMapIcon({Key key,}) : super(key: key);

  @override
  _AddMapIconState createState() => _AddMapIconState();
}


class _AddMapIconState extends State<AddMapIcon>{

  Future<String> getAddressByLocation(LatLng location) async{
    final List<Placemark> placemark = await placemarkFromCoordinates(location.latitude, location.longitude);

    return Future.value("${placemark[0].street}, ${placemark[0].postalCode} ${placemark[0].locality}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Element hinzufügen'),
      ),
      drawer: MyDrawer(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget> [
                FutureBuilder<String>(          //catch geocode
                  future: getAddressByLocation(globals.tappedPoint),
                  builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return Text('Standort: ${snapshot.data}');
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ShowList()),    //opens selectionList
                    ).then(onGoBack);                                         //updates globals.chosenElement
                  },
                  child: Text(globals.chosenElement),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    globals.chosenElement = 'wähle ein Element';
                    Navigator.pop(context);
                  },
                  child: Text('Abbrechen'),
                ),
                ElevatedButton(
                  onPressed: () {
                    //save to database, show on map
                    setState(() {
                      globals.markerList.add(Marker(
                          markerId: MarkerId(globals.tappedPoint.toString()), //if tappedPoint is null, use current camera location
                          position: globals.tappedPoint,
                          ));
                    });
                    globals.chosenElement = 'wähle ein Element';
                    Navigator.pop(context);
                  },
                  child: Text('Speichern'),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }

  FutureOr onGoBack(dynamic value){
    globals.chosenElement = globals.chosenElement;
    setState((){});
  }
}

class ShowList extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
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
            SubList(
              elementType: 'Element',
            ),
            SubList(
              elementType: 'Plant',
            ),
            SubList(
              elementType: 'Method',
            )
          ],
        ),
      ),
    );
  }
}

//This class needs to be replaced: load the elements from database and change each list element into expandable
class SubList extends StatefulWidget {
  SubList({Key key, this.elementType}) : super(key: key);

  final String elementType;

  @override
  _SubListState createState() => _SubListState();
}

class _SubListState extends State<SubList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('biodiversityMeasures')
                .where('type', isEqualTo: widget.elementType.toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final List<BiodiversityMeasure> list = [];
              for (final DocumentSnapshot in snapshot.data.documents) {
                list.add(BiodiversityMeasure.fromSnapshot(DocumentSnapshot));
              }
              if (list.isEmpty) {
                return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Text(
                          "Leider keine Einträge vorhanden",
                          textScaleFactor: 2,
                          textAlign: TextAlign.center,
                        ),
                        Icon(
                          Icons.emoji_nature,
                          size: 80,
                        )
                      ],
                    ));
              }
              return ListView.separated(
                itemCount: list.length,
                itemBuilder: (BuildContext context, int index) {
                  final element = list.elementAt(index);
                  final desc = "${element.description.trim()}";
                  return SelectElementCard(
                      element.name,
                      desc,
                      AssetImage(element.imageSource));
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(height: 5);
                },
              );
            }),
      ),
    );
  }
}

//Remove class BiodiversityMeasure and import biodiversity_measure.dart when merched branch of Gabriel TODO
class BiodiversityMeasure {
  final String name;
  final String description;
  final String buildInstructions;
  final String type;
  final Map<String, bool> beneficialFor;
  final Map<String, bool> badFor;
  final String imageSource;
  final DocumentReference reference;

  BiodiversityMeasure(this.name, this.description, this.buildInstructions,
      this.type, this.beneficialFor, this.reference, this.imageSource, this.badFor);

  BiodiversityMeasure.fromMap(Map<String, dynamic> map, {this.reference})
      : name = map.containsKey('name') ? map['name'] as String : "",
        description =
        map.containsKey('description') ? map['description'] as String : "",
        buildInstructions = map.containsKey('buildInstructions')
            ? map['buildInstructions'] as String
            : "",
        type = map.containsKey('type') ? map['type'] as String : "",
        beneficialFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        badFor = map.containsKey('beneficialFor')
            ? Map<String, bool>.from(map['beneficialFor'] as Map)
            : Map<String, bool>.identity(),
        imageSource =
        map.containsKey('image') ? map['image'] as String : 'res/logo.png' {
    beneficialFor.removeWhere((key, value) => !value);
    badFor.removeWhere((key, value) => value);
  }

  BiodiversityMeasure.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);
}


class SelectElementCard extends StatefulWidget {  //same as structural_element_card_widget.dart, but with less infos, not expandable and selectable
  final String name;
  final String description;
  final AssetImage image;

  const SelectElementCard(
      this.name, this.description, this.image);

  @override
  _selectElementCardState createState() => _selectElementCardState();
}

class _selectElementCardState extends State<SelectElementCard> {

  String getShortDesc(String s){
    if (s.length >= 25){
      return "${s.substring(0, 25)}...";
    }else{
      return s;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        _tappedCard(widget.name);
        Navigator.pop(context);
      },
      child:     Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(3)),
          border: Border.all(
            color: const Color.fromRGBO(200, 200, 200, 1),
          ),
        ),
        child: ListTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.name,
                    style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 16)),
                  Text(getShortDesc(widget.description)),
                ],
              ),
              Image(
                width: 60,
                height: 60,
                fit: BoxFit.cover,
                image: widget.image,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _tappedCard(String title){
    globals.chosenElement = title;
  }
}
