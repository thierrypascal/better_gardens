import 'dart:developer' as logging;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/cupertino.dart';

class SubMap extends StatefulWidget {
  SubMap(
      this.latitude,
      this.longitude,
      {
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
    tempMarkerList.add(Marker(
      markerId: MarkerId('temp'),
      position: LatLng(widget.latitude, widget.longitude),
      onTap: (){},
    ));
    setState(() {});
  }

  void _setPosition(LatLng tapPos) {
    setState(() {
      tempMarkerList=[];
      tempMarkerList.add(Marker(
          markerId: MarkerId('temp'),
          position: tapPos,
          onTap: (){},
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height/3,
        child: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: LatLng(widget.latitude, widget.longitude),
            zoom: 18.0,
          ),
          zoomControlsEnabled: false,
          mapType: MapType.hybrid,
          markers: Set.from(tempMarkerList),
          onTap: _setPosition,
        ),
      );
  }
}
