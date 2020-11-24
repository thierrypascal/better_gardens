import 'dart:async';
import 'dart:developer' as logging;
import 'package:biodiversity/globals.dart' as globals;
import 'package:biodiversity/drawer.dart';
import 'package:biodiversity/maps_add_map_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
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
