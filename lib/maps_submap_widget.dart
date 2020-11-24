import 'dart:developer' as logging;
import 'package:biodiversity/globals.dart' as globals;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

class SubMap extends StatefulWidget {
  SubMap(
      this.latitude,
      this.longitude, {
        Key key,
      }) : super(key: key);
  final double latitude;
  final double longitude;

  @override
  _SubMapState createState() => _SubMapState();
}

class _SubMapState extends State<SubMap> {
  GoogleMapController mapController;
  List<Marker> tempMarkerList = <Marker>[];

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() {});
  }

  void _setPosition(LatLng tapPos) {


    globals.tappedPoint = tapPos;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: CameraPosition(
          target: LatLng(widget.latitude, widget.longitude),
          zoom: 14.0,
        ),
        zoomControlsEnabled: false,
        mapType: MapType.hybrid,
        markers: Set.from(tempMarkerList),
        onTap: _setPosition,
      ),
    );
  }
}
