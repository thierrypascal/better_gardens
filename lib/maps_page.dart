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
          _addMarker(tapPosition);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }

  _addMarker(LatLng tappedPoint) {
    setState(() {
      myMarker.add(Marker(
          markerId: MarkerId(tappedPoint.toString()),
          position: tappedPoint,
          draggable: true,
          onDragEnd: (dragEndPosition) {
            logging.log(dragEndPosition.toString());
          }));
    });
  }
}
